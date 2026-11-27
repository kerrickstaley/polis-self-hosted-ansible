FROM python:3.12-slim@sha256:191083cdf6c7bda8c76158983163ead5d5cf7b77cf3033e805bb0f5296f51b4b
WORKDIR /app
COPY requirements.lock .
# The vote-clustering worker uses these packages from the upstream lock.
RUN grep -E '^(boto3|numpy|pandas|psycopg2-binary|pyyaml|scikit-learn|scipy|sqlalchemy)==' requirements.lock > math-requirements.txt \
 && sed -E 's/^([a-zA-Z0-9_.-]+)\[[^]]+\]==/\1==/' requirements.lock > constraints.txt \
 && pip install --no-cache-dir -c constraints.txt -r math-requirements.txt
COPY polismath polismath
COPY scripts/math_poller.py scripts/math_poller.py
ENV PYTHONPATH=/app
CMD ["python", "scripts/math_poller.py"]
