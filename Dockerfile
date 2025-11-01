# Use official Python image
FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# create and give unroot user right to write
RUN useradd -m appuser

# Set working directory to project root
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire src folder (keeping internal structure)
COPY src ./src
RUN chmod -R 777 /app/src

# Set default command
CMD ["python", "src/app/main.py"]


