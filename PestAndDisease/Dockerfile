FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
# Install non-PyTorch packages first, then PyTorch from CPU index
RUN pip install --no-cache-dir flask flask-cors pillow numpy timm && \
    pip install --no-cache-dir torch torchvision --index-url https://download.pytorch.org/whl/cpu

# Copy model file explicitly (before copying other files)
COPY best_vit_wheat_model_4classes.pth ./

# Copy application files
COPY . .

# Tạo non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 5001

# Set environment variables
ENV PORT=5001
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=pest_disease_service.py

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:5001/health || exit 1

# Run the application
CMD ["python", "pest_disease_service.py"]


CMD ["python", "pest_disease_service.py"]

