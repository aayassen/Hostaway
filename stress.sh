#!/bin/bash

# Configuration
URL="http://localhost"  # Replace with your Nginx application URL
CONNECTIONS=100              # Number of concurrent connections
DURATION=60                  # Test duration in seconds
THREADS=5                   # Number of threads to use
OUTPUT_FILE="stress_test_results_$(date +%Y-%m-%d_%H-%M-%S).txt"

# Check if wrk is installed
if ! command -v wrk &> /dev/null; then
    echo "Error: wrk is not installed. Install it using 'brew install wrk'."
    exit 1
fi

# Check if URL is reachable
if ! curl -s -o /dev/null -I "$URL"; then
    echo "Error: The URL $URL is not reachable."
    exit 1
fi

# Run the stress test
echo "Starting stress test on $URL with $CONNECTIONS connections for $DURATION seconds..."
wrk -t"$THREADS" -c"$CONNECTIONS" -d"$DURATION"s "$URL" | tee "$OUTPUT_FILE"

# Summary
echo "Stress test completed. Results saved to $OUTPUT_FILE"