from boto import ec2
import sys
'''
define a function to get all instance id
'''
def get_instance_list(my_reserve):
    my_inst_instances = {}
    for nums in range(0,len(my_reserve)):
        if len(my_reserve[nums].instances) > 1:
            for num in range(0,len(my_reserve[nums].instances)):
                my_inst_instances[my_reserve[nums].instances[num].__str__()] = my_reserve[nums].instances[num].__dict__
        else:
            my_inst_instances[my_reserve[nums].instances[0].__str__()] = my_reserve[nums].instances[0].__dict__
    return my_inst_instances

# define a connection to connect aws console
def get_conn_env():
    env_list = ["demo", "prod","test"]
    if len(sys.argv) > 1:
	env = sys.argv[1]
        if env_list.count(sys.argv[1]) > 0:
            ec2_conn = ec2.connect_to_region("eu-west-1", profile_name = env)
        else:
            print "You need to input the right $ENV."
            exit()
    elif len(sys.argv) == 1:
        ec2_conn = ec2.connect_to_region("eu-west-1")
    my_reserves = ec2_conn.get_all_reservations()
    return my_reserves

#output simple columns according to AWS console
def output_inst_info_simp(my_dict):
    print "           Name                     ID        Type         State         Public_IP       Private_IP        Key                  AMI"
    for key in  my_dict.keys():
	if 'Name' in my_dict[key]['tags']:
        	print "%25s %15s %10s %15s %15s %15s %15s %20s" %(my_dict[key]['tags']['Name'], 
                                                         my_dict[key]['id'], 
                                                        my_dict[key]['instance_type'], 
                                                        my_dict[key]['_state'], 
                                                        my_dict[key]['ip_address'], 
                                                        my_dict[key]['private_ip_address'], 
                                                        my_dict[key]['key_name'],
                                                        my_dict[key]['image_id'])
output_inst_info_simp(get_instance_list(get_conn_env()))
