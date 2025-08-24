from collections import Counter

def parse_logs(log_string):
    statuses = []

    for line in log_string.splitlines():
        if line.strip():  # Skip empty or whitespace-only lines
            parts = line.strip().split(',')
            if len(parts) == 2:
                _, status = parts
                statuses.append(status.strip())

    return dict(Counter(statuses))

with open('log_string.txt', 'r') as file:
    log_string = file.read()

result = parse_logs(log_string)
print(result)  # Output: {'SUCCESS': 2, 'FAILURE': 2, 'TIMEOUT': 1}
