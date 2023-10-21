# Stage 1: Build the application
FROM python:3.8 AS builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create and set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install -r requirements.txt

# Copy the project code into the container
COPY . /app/

# Copy the wait-for-it.sh script and make it executable
COPY wait-for-it.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wait-for-it.sh

# Stage 2: Run the application
FROM builder AS runner

# Use wait-for-it.sh to wait for the database service
CMD ["wait-for-it.sh", "db:5432", "--", "python3", "manage.py", "migrate"]

# Set the STATIC_ROOT setting
RUN echo "STATIC_ROOT = '/static/'" >> myproject/settings.py

# Collect static files if needed
RUN python manage.py collectstatic --noinput

# Start the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]
