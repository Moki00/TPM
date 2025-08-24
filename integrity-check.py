def check_data_integrity(devices):
    return 0
# that takes a list of dictionaries.
# Each dictionary should have the keys 'device_id' and 'status'.
# If a dictionary is missing either of these keys,
# the function should return False.
# If all dictionaries are complete, it should return True.



# check_data_integrity(devices_valid) should return True.
# check_data_integrity(devices_invalid) should return False.

# Iterate through the list of dictionaries.
# For each dictionary,
# use the in operator to check if 'device_id' and 'status' are present.
# If you find any dictionary that's missing a key,
# immediately return False.
# If you get through the entire loop without returning False,
# return True at the end.