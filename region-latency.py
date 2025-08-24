import ast

def find_bottlenecks(region_latency, threshold):
    bottlenecks = []

    for region, latency in region_latency.items():
        if latency > threshold:
            bottlenecks.append(region)

    return bottlenecks

with open('region_latency.txt', 'r') as file:
    content = file.read()
    region_latency = ast.literal_eval(content)

# print(find_bottlenecks(region_latency, 100))

with open('output.txt', 'w') as output_file:
    for region in find_bottlenecks(region_latency, 100):
        output_file.write(region+'\n')