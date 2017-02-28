pragma solidity ^0.4.8;

import "Token.sol";
import "Ownable.sol";

contract Proxy is Ownable {

  // stores authorized addresses
  mapping (address => bool) public authorities;

  event LogAuthorizationChange(address indexed target, bool value, address indexed caller);

  // only authorized addresses can invoke functions with this modifier
  modifier onlyAuthorized {
    if (authorities[msg.sender] != true) throw;
    _;
  }

  // Proxy calls into ERC20 Token contract, invoking transferFrom
  function transferFrom(
    address _token,
    address _from,
    address _to,
    uint256 _value)
    onlyAuthorized
    returns (bool success)
  {
    Token(_token).transferFrom(_from, _to, _value);
    return true;
  }

  function setAuthorization(address _target, bool _value)
    onlyOwner
    returns (bool success)
  {
    authorities[_target] = _value;
    LogAuthorizationChange(_target, _value, msg.sender);
    return true;
  }

  function isAuthorized(address _target)
    constant
    returns (bool _value)
  {
    return authorities[_target];
  }

}