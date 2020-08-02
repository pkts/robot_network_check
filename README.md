Robot Framework Test-Drive: Network Testing
===========================================

It seems surprisingly straight-forward to write up automated network testing
using Robot Framework. Almost no programming skills required.

Instead of the built-in SSHLibrary I had to use Netmiko (see NetmikoHelper.py).
Not surprisingly, seems there are some ssh idiosyncrasies with Cisco IOS.


Install
=======
```
pip install robotframework
pip install netmiko
```


Running Output Example
======================
```
(network_check) √ network_check % robot checks.robot                      
==============================================================================
Checks :: Internet Connectivity testing, and BGP checks                       
==============================================================================
Connect to all devices                                                | PASS |
------------------------------------------------------------------------------
Layer 3 Tests                                                         | PASS |
------------------------------------------------------------------------------
Check that BGP Sessions are all in Established State                  | PASS |
------------------------------------------------------------------------------
Check that 1.1.1.1 loopback is in BGP table on C7200 and IOSvL3       | PASS |
------------------------------------------------------------------------------
Close All Connections                                                 | PASS |
------------------------------------------------------------------------------
Checks :: Internet Connectivity testing, and BGP checks               | PASS |
5 critical tests, 5 passed, 0 failed
5 tests total, 5 passed, 0 failed
==============================================================================
Output:  /Users/vpattni/local/Projects/robot/network_check/output.xml
Log:     /Users/vpattni/local/Projects/robot/network_check/log.html
Report:  /Users/vpattni/local/Projects/robot/network_check/report.html
```
