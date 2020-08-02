# Check the network health

*** Settings ***
Documentation       Check for network correctness
Library             NetmikoHelper.py
Suite Setup         Open Connections and Log In
Suite Teardown      Close All Connections


*** Variables ***
&{C7200}        hostname=C7200   host=10.0.0.2   username=admin  password=cisco  device_type=cisco_ios
&{IOSvL3}       hostname=IOSvL3  host=10.0.0.6   username=admin  password=cisco  device_type=cisco_ios


*** Test Cases ***
Layer 3 Tests
    Internet Connectivity Ping Test

BGP Session State Checks
    Check BGP Neighbor State       ${C7200}[hostname]       peer=10.0.0.1
    Check BGP Neighbor State       ${IOSvL3}[hostname]      peer=10.0.0.5

Check All Loopbacks are in BGP Table on host ${C7200}[hostname]
    Check BGP Table     ${C7200}[hostname]      prefix=1.1.1.1/32      nexthop=10.0.0.1
    Check BGP Table     ${C7200}[hostname]      prefix=2.2.2.2/32      nexthop=0.0.0.0
    Check BGP Table     ${C7200}[hostname]      prefix=3.3.3.3/32      nexthop=10.0.0.1

Check All Loopbacks are in BGP Table on host ${IOSvL3}[hostname]
    Check BGP Table     ${IOSvL3}[hostname]      prefix=1.1.1.1/32      nexthop=10.0.0.5
    Check BGP Table     ${IOSvL3}[hostname]      prefix=2.2.2.2/32      nexthop=10.0.0.5
    Check BGP Table     ${IOSvL3}[hostname]      prefix=3.3.3.3/32      nexthop=0.0.0.0


*** Keywords ***
Open Connections and Log In
    Open Session        ${C7200}[host]   ${C7200}[username]   ${C7200}[password]   ${C7200}[device_type]    ${C7200}[hostname]
    Open Session        ${IOSvL3}[host]  ${IOSvL3}[username]  ${IOSvL3}[password]  ${IOSvL3}[device_type]   ${IOSvL3}[hostname]

Close All Connections
    Close Session   ${C7200}[hostname]
    Close Session   ${IOSvL3}[hostname]

Internet Connectivity Ping Test
    [Documentation]     Internet Ping test
    ${output}=          Send Command        ping 3.3.3.3 source 2.2.2.2     ${C7200}[hostname]
    Should Contain      ${output}           Success rate is 100 percent


Check BGP Neighbor State
    [Documentation]     Check if Neighbor BGP state is in "Established" state
    [Arguments]         ${hostname}         ${peer}
    ${output}=          Send Command        show ip bgp nei ${peer}     ${hostname}
    Should Contain      ${output}           BGP state = Established

Check BGP Table
    [Documentation]     Check if a prefix exists in the BGP table with the specified nexthop
    [Arguments]         ${hostname}         ${prefix}   ${nexthop}
    ${output}=          Send Command        show ip bgp ${prefix}     ${hostname}
    Should Contain      ${output}           ${nexthop}
