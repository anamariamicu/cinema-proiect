FROM python:3.6
WORKDIR /admin
COPY requirements.txt ./
RUN pip install -U setuptools
RUN pip install -r requirements.txt
COPY src /admin
CMD ["python", "admin.py"]