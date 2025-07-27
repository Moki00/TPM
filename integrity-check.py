import ast

def check_data_integrity(devices):
    # Each dictionary should have the keys 'device_id' and 'status'.
    required_keys = ['device_id','status']

    for device in devices:
        for key in required_keys:
            if key not in device:
                return False
    return True # If all dictionaries are complete, return True.

file1 = 'integrity_pass.txt'
with open(file1,'r') as pass_file:
    content= pass_file.read()
    check = ast.literal_eval(content)

with open('output.txt','w') as file:
    file.write(file1+f" is {check_data_integrity(check)}")

file2 = 'integrity_fail.txt'
with open(file2,'r') as fail_file:
    content= fail_file.read()
    check = ast.literal_eval(content)

with open('output.txt','a') as file:
    file.write('\n'+file2+f" is {check_data_integrity(check)}")
