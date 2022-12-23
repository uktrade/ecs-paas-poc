FROM python:3-alpine

RUN apk add --no-cache postgresql-libs gcc musl-dev postgresql-dev

RUN pip install psycopg2

COPY simple2.py /

CMD ["python","-u","simple2.py"]
