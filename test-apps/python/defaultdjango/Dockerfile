FROM python:3-alpine

RUN pip install django

COPY defaultdjango/ /

CMD ["python","manage.py","runserver","0.0.0.0:8000"]
