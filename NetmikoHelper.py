from netmiko import ConnectHandler

class NetmikoHelper():
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def __init__(self):
        self.net_connect = {}
        self.device = ""

    def open_session(self,ip,username,password,device,hostname):
        # open session to target device
        if hostname in self.net_connect:
            pass
        else:
            # make SSH session to router
            handler = {
                'device_type': device,
                'ip': ip,
                'username': username,
                'password': password,
            }
            self.net_connect[hostname] = ConnectHandler(**handler)
            self.device = device
            if self.device == "arista_eos":
                self.net_connect[hostname].enable()
            print("[INFO] Successfully make SSH connection to {}".format(hostname))



    def close_session(self,hostname):
        # close existing session
        self.net_connect[hostname].disconnect()
        del self.net_connect[hostname]
        print("[INFO] Successfully close SSH connection to {}".format(hostname))



    def send_command(self,command,hostname):
        # send command to target device
        out = self.net_connect[hostname].send_command(command)
        print("[INFO] Successfully get output of command<{}> from {}".format(command,hostname))
        print("="*30)
        print(out)
        print("="*30)
        return out
