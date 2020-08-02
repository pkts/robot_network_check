# Robot script to check Internet reachability and BGP Health

*** Settings ***
Documentation       Internet Connectivity testing, and BGP checks
Library             NetmikoHelper.py

*** Variables ***
&{C7200}        hostname=C7200   host=10.0.0.2   username=admin  password=cisco  device_type=cisco_ios
&{IOSvL3}       hostname=IOSvL3  host=10.0.0.6   username=admin  password=cisco  device_type=cisco_ios
&{IOU2}         hostname=IOU2    host=10.0.0.10   username=admin  password=cisco  device_type=cisco_ios_telnet     port=23


*** Test Cases ***
Connect to all devices
    Connect     ${C7200}[host]   ${C7200}[username]   ${C7200}[password]   ${C7200}[device_type]    ${C7200}[hostname]
    Connect     ${IOSvL3}[host]  ${IOSvL3}[username]  ${IOSvL3}[password]  ${IOSvL3}[device_type]   ${IOSvL3}[hostname]
    Connect     ${IOU2}[host]    ${IOU2}[username]    ${IOU2}[password]    ${IOU2}[device_type]     ${IOU2}[hostname]   ${IOU2}[port]

Layer 3 Tests
    Internet Connectivity Ping Test

Check that BGP Sessions are all in Established State
    Check BGP Neighbor State       ${C7200}[hostname]       peer=10.0.0.1
    Check BGP Neighbor State       ${IOSvL3}[hostname]      peer=10.0.0.5
    Check BGP Neighbor State       ${IOU2}[hostname]        peer=10.0.0.2
    Check BGP Neighbor State       ${IOU2}[hostname]        peer=10.0.0.6

Check that 1.1.1.1 loopback is in BGP table on C7200 and IOSvL3
    Check BGP Table     ${C7200}[hostname]      prefix=1.1.1.1/32      nexthop=10.0.0.1
    Check BGP Table     ${IOSvL3}[hostname]      prefix=1.1.1.1/32      nexthop=10.0.0.5

Close All Connections
    Disconnect          ${C7200}[hostname]
    Disconnect          ${IOSvL3}[hostname]
    Disconnect          ${IOU2}[hostname]


*** Keywords ***
Connect
    [Documentation]     Connection to device using NetmikoHelper
    [Arguments]         ${host}     ${username}     ${password}     ${device_type}      ${hostname}     ${port}=22
    Open Session        ${host}     ${username}     ${password}     ${device_type}      ${hostname}     ${port}


Disconnect
    [Documentation]     Teardown connection to network device
    [Arguments]         ${hostname}
    Close Session       ${hostname}


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
