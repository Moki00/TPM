
def parse_logs(log_string):
    statuses = {}
    lines = log_string.splitlines()
    for line in lines:
        if line.strip():
            _, status = line.split(',')
            status = status.strip()
            
            if status in statuses:
                statuses[status]+=1
            else:
                statuses[status]=1
    return statuses

with open('log_string.txt', 'r') as file:
    log_string = file.read()

print(parse_logs(log_string))