from netmiko import ConnectHandler

'''
    Maintain multiple device connection handles
'''
class NetmikoHelper():
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def __init__(self):
        self.net_connect = {}
        self.device = ""

    def open_session(self,ip,username,password,device,hostname,port=22):
        if hostname in self.net_connect:
            pass
        else:
            handler = {
                'device_type': device,
                'ip': ip,
                'username': username,
                'password': password,
                'port': port,
            }
            self.net_connect[hostname] = ConnectHandler(**handler)
            self.device = device

    def close_session(self,hostname):
        self.net_connect[hostname].disconnect()
        del self.net_connect[hostname]

    def send_command(self,command,hostname):
        return self.net_connect[hostname].send_command(command)
