FROM python:alpine

# Install requirements
RUN pip install flask requests gunicorn 

RUN apk --no-cache add curl
# Add demo app
COPY . /app
WORKDIR /app

CMD ["gunicorn", "-b", "0.0.0.0:8000", "app:app"]
EXPOSE 8000
