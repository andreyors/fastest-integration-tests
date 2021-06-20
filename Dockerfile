FROM python:3.9-buster AS build

ARG PORT=8000

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.1.5 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv" \
    PORT=$PORT

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

FROM build AS base

RUN set -xe \
    && mkdir -p /code

WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./

RUN set -xe \
    && apt-get update -yqq \
    && apt-get install --no-install-recommends -yqq \
        curl \
        build-essential \
    && curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python - \
    && poetry install --no-dev

FROM base AS dev

WORKDIR $PYSETUP_PATH
COPY --from=base $POETRY_HOME $POETRY_HOME
COPY --from=base $PYSETUP_PATH $PYSETUP_PATH

RUN poetry install

WORKDIR /code

EXPOSE 8000

CMD ["uvicorn", "--reload", "--host=0.0.0.0", "--port=$PORT", "app.wsgi:application"]

FROM base AS production

COPY --from=base $PYSETUP_PATH $PYSETUP_PATH
COPY gunicorn_conf.py /gunicorn_conf.py
COPY . /code/

WORKDIR /code

CMD ["gunicorn", "--worker-class uvicorn.workers.UvicornWorker", "--config /gunicorn_conf.py", "app.wsgi:application"]
