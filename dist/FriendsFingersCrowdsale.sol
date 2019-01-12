pragma solidity ^0.4.24;

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    emit Unpause();
  }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * See https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address _who) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address _owner, address _spender)
    public view returns (uint256);

  function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool);

  function approve(address _spender, uint256 _value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // assert(_b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}

// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
  function safeTransfer(
    ERC20Basic _token,
    address _to,
    uint256 _value
  )
    internal
  {
    require(_token.transfer(_to, _value));
  }

  function safeTransferFrom(
    ERC20 _token,
    address _from,
    address _to,
    uint256 _value
  )
    internal
  {
    require(_token.transferFrom(_from, _to, _value));
  }

  function safeApprove(
    ERC20 _token,
    address _spender,
    uint256 _value
  )
    internal
  {
    require(_token.approve(_spender, _value));
  }
}

// File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
 * the methods to add functionality. Consider using 'super' where appropriate to concatenate
 * behavior.
 */
contract Crowdsale {
  using SafeMath for uint256;
  using SafeERC20 for ERC20;

  // The token being sold
  ERC20 public token;

  // Address where funds are collected
  address public wallet;

  // How many token units a buyer gets per wei.
  // The rate is the conversion between wei and the smallest and indivisible token unit.
  // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
  // 1 wei will give you 1 unit, or 0.001 TOK.
  uint256 public rate;

  // Amount of wei raised
  uint256 public weiRaised;

  /**
   * Event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value,
    uint256 amount
  );

  /**
   * @param _rate Number of token units a buyer gets per wei
   * @param _wallet Address where collected funds will be forwarded to
   * @param _token Address of the token being sold
   */
  constructor(uint256 _rate, address _wallet, ERC20 _token) public {
    require(_rate > 0);
    require(_wallet != address(0));
    require(_token != address(0));

    rate = _rate;
    wallet = _wallet;
    token = _token;
  }

  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------

  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    buyTokens(msg.sender);
  }

  /**
   * @dev low level token purchase ***DO NOT OVERRIDE***
   * @param _beneficiary Address performing the token purchase
   */
  function buyTokens(address _beneficiary) public payable {

    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    _processPurchase(_beneficiary, tokens);
    emit TokenPurchase(
      msg.sender,
      _beneficiary,
      weiAmount,
      tokens
    );

    _updatePurchasingState(_beneficiary, weiAmount);

    _forwardFunds();
    _postValidatePurchase(_beneficiary, weiAmount);
  }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

  /**
   * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
   * Example from CappedCrowdsale.sol's _preValidatePurchase method: 
   *   super._preValidatePurchase(_beneficiary, _weiAmount);
   *   require(weiRaised.add(_weiAmount) <= cap);
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    require(_beneficiary != address(0));
    require(_weiAmount != 0);
  }

  /**
   * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
   * @param _beneficiary Address performing the token purchase
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _postValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    // optional override
  }

  /**
   * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
   * @param _beneficiary Address performing the token purchase
   * @param _tokenAmount Number of tokens to be emitted
   */
  function _deliverTokens(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    token.safeTransfer(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
   * @param _beneficiary Address receiving the tokens
   * @param _tokenAmount Number of tokens to be purchased
   */
  function _processPurchase(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    _deliverTokens(_beneficiary, _tokenAmount);
  }

  /**
   * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
   * @param _beneficiary Address receiving the tokens
   * @param _weiAmount Value in wei involved in the purchase
   */
  function _updatePurchasingState(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    // optional override
  }

  /**
   * @dev Override to extend the way in which ether is converted to tokens.
   * @param _weiAmount Value in wei to be converted into tokens
   * @return Number of tokens that can be purchased with the specified _weiAmount
   */
  function _getTokenAmount(uint256 _weiAmount)
    internal view returns (uint256)
  {
    return _weiAmount.mul(rate);
  }

  /**
   * @dev Determines how ETH is stored/forwarded on purchases.
   */
  function _forwardFunds() internal {
    wallet.transfer(msg.value);
  }
}

// File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) internal balances;

  uint256 internal totalSupply_;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value <= balances[msg.sender]);
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}

// File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/issues/20
 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(_to != address(0));

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

// File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol

/**
 * @title Mintable token
 * @dev Simple ERC20 Token example, with mintable token creation
 * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
 */
contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  modifier hasMintPermission() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address _to,
    uint256 _amount
  )
    public
    hasMintPermission
    canMint
    returns (bool)
  {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() public onlyOwner canMint returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
}

// File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol

/**
 * @title MintedCrowdsale
 * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
 * Token ownership should be transferred to MintedCrowdsale for minting.
 */
contract MintedCrowdsale is Crowdsale {

  /**
   * @dev Overrides delivery by minting tokens upon purchase.
   * @param _beneficiary Token purchaser
   * @param _tokenAmount Number of tokens to be minted
   */
  function _deliverTokens(
    address _beneficiary,
    uint256 _tokenAmount
  )
    internal
  {
    // Potentially dangerous assumption about the type of the token.
    require(MintableToken(address(token)).mint(_beneficiary, _tokenAmount));
  }
}

// File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol

/**
 * @title CappedCrowdsale
 * @dev Crowdsale with a limit for total contributions.
 */
contract CappedCrowdsale is Crowdsale {
  using SafeMath for uint256;

  uint256 public cap;

  /**
   * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
   * @param _cap Max amount of wei to be contributed
   */
  constructor(uint256 _cap) public {
    require(_cap > 0);
    cap = _cap;
  }

  /**
   * @dev Checks whether the cap has been reached.
   * @return Whether the cap was reached
   */
  function capReached() public view returns (bool) {
    return weiRaised >= cap;
  }

  /**
   * @dev Extend parent behavior requiring purchase to respect the funding cap.
   * @param _beneficiary Token purchaser
   * @param _weiAmount Amount of wei contributed
   */
  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    super._preValidatePurchase(_beneficiary, _weiAmount);
    require(weiRaised.add(_weiAmount) <= cap);
  }

}

// File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol

/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame.
 */
contract TimedCrowdsale is Crowdsale {
  using SafeMath for uint256;

  uint256 public openingTime;
  uint256 public closingTime;

  /**
   * @dev Reverts if not in crowdsale time range.
   */
  modifier onlyWhileOpen {
    // solium-disable-next-line security/no-block-members
    require(block.timestamp >= openingTime && block.timestamp <= closingTime);
    _;
  }

  /**
   * @dev Constructor, takes crowdsale opening and closing times.
   * @param _openingTime Crowdsale opening time
   * @param _closingTime Crowdsale closing time
   */
  constructor(uint256 _openingTime, uint256 _closingTime) public {
    // solium-disable-next-line security/no-block-members
    require(_openingTime >= block.timestamp);
    require(_closingTime >= _openingTime);

    openingTime = _openingTime;
    closingTime = _closingTime;
  }

  /**
   * @dev Checks whether the period in which the crowdsale is open has already elapsed.
   * @return Whether crowdsale period has elapsed
   */
  function hasClosed() public view returns (bool) {
    // solium-disable-next-line security/no-block-members
    return block.timestamp > closingTime;
  }

  /**
   * @dev Extend parent behavior requiring to be within contributing period
   * @param _beneficiary Token purchaser
   * @param _weiAmount Amount of wei contributed
   */
  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
    onlyWhileOpen
  {
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }

}

// File: openzeppelin-solidity/contracts/crowdsale/distribution/FinalizableCrowdsale.sol

/**
 * @title FinalizableCrowdsale
 * @dev Extension of Crowdsale where an owner can do extra work
 * after finishing.
 */
contract FinalizableCrowdsale is Ownable, TimedCrowdsale {
  using SafeMath for uint256;

  bool public isFinalized = false;

  event Finalized();

  /**
   * @dev Must be called after crowdsale ends, to do some extra finalization
   * work. Calls the contract's finalization function.
   */
  function finalize() public onlyOwner {
    require(!isFinalized);
    require(hasClosed());

    finalization();
    emit Finalized();

    isFinalized = true;
  }

  /**
   * @dev Can be overridden to add finalization logic. The overriding function
   * should call super.finalization() to ensure the chain of finalization is
   * executed entirely.
   */
  function finalization() internal {
  }

}

// File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol

/**
 * @title DetailedERC20 token
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 */
contract DetailedERC20 is ERC20 {
  string public name;
  string public symbol;
  uint8 public decimals;

  constructor(string _name, string _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }
}

// File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is BasicToken {

  event Burn(address indexed burner, uint256 value);

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */
  function burn(uint256 _value) public {
    _burn(msg.sender, _value);
  }

  function _burn(address _who, uint256 _value) internal {
    require(_value <= balances[_who]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    balances[_who] = balances[_who].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
    emit Burn(_who, _value);
    emit Transfer(_who, address(0), _value);
  }
}

// File: openzeppelin-solidity/contracts/AddressUtils.sol

/**
 * Utility library of inline functions on addresses
 */
library AddressUtils {

  /**
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract,
   * as the code is not actually created until after the constructor finishes.
   * @param _addr address to check
   * @return whether the target address is a contract
   */
  function isContract(address _addr) internal view returns (bool) {
    uint256 size;
    // XXX Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // See https://ethereum.stackexchange.com/a/14016/36603
    // for more details about how this works.
    // TODO Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solium-disable-next-line security/no-inline-assembly
    assembly { size := extcodesize(_addr) }
    return size > 0;
  }

}

// File: openzeppelin-solidity/contracts/introspection/ERC165.sol

/**
 * @title ERC165
 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
 */
interface ERC165 {

  /**
   * @notice Query if a contract implements an interface
   * @param _interfaceId The interface identifier, as specified in ERC-165
   * @dev Interface identification is specified in ERC-165. This function
   * uses less than 30,000 gas.
   */
  function supportsInterface(bytes4 _interfaceId)
    external
    view
    returns (bool);
}

// File: openzeppelin-solidity/contracts/introspection/SupportsInterfaceWithLookup.sol

/**
 * @title SupportsInterfaceWithLookup
 * @author Matt Condon (@shrugs)
 * @dev Implements ERC165 using a lookup table.
 */
contract SupportsInterfaceWithLookup is ERC165 {

  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;
  /**
   * 0x01ffc9a7 ===
   *   bytes4(keccak256('supportsInterface(bytes4)'))
   */

  /**
   * @dev a mapping of interface id to whether or not it's supported
   */
  mapping(bytes4 => bool) internal supportedInterfaces;

  /**
   * @dev A contract implementing SupportsInterfaceWithLookup
   * implement ERC165 itself
   */
  constructor()
    public
  {
    _registerInterface(InterfaceId_ERC165);
  }

  /**
   * @dev implement supportsInterface(bytes4) using a lookup table
   */
  function supportsInterface(bytes4 _interfaceId)
    external
    view
    returns (bool)
  {
    return supportedInterfaces[_interfaceId];
  }

  /**
   * @dev private method for registering an interface
   */
  function _registerInterface(bytes4 _interfaceId)
    internal
  {
    require(_interfaceId != 0xffffffff);
    supportedInterfaces[_interfaceId] = true;
  }
}

// File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol

/**
 * @title ERC1363 interface
 * @author Vittorio Minacori (https://github.com/vittominacori)
 * @dev Interface for a Payable Token contract as defined in
 *  https://github.com/ethereum/EIPs/issues/1363
 */
contract ERC1363 is ERC20, ERC165 {
  /*
   * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
   * 0x4bbee2df ===
   *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
   *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
   *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
   *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
   */

  /*
   * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
   * 0xfb9ec8ce ===
   *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
   *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
   */

  /**
   * @notice Transfer tokens from `msg.sender` to another address
   *  and then call `onTransferReceived` on receiver
   * @param _to address The address which you want to transfer to
   * @param _value uint256 The amount of tokens to be transferred
   * @return true unless throwing
   */
  function transferAndCall(address _to, uint256 _value) public returns (bool);

  /**
   * @notice Transfer tokens from `msg.sender` to another address
   *  and then call `onTransferReceived` on receiver
   * @param _to address The address which you want to transfer to
   * @param _value uint256 The amount of tokens to be transferred
   * @param _data bytes Additional data with no specified format, sent in call to `_to`
   * @return true unless throwing
   */
  function transferAndCall(address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len

  /**
   * @notice Transfer tokens from one address to another
   *  and then call `onTransferReceived` on receiver
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 The amount of tokens to be transferred
   * @return true unless throwing
   */
  function transferFromAndCall(address _from, address _to, uint256 _value) public returns (bool); // solium-disable-line max-len


  /**
   * @notice Transfer tokens from one address to another
   *  and then call `onTransferReceived` on receiver
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 The amount of tokens to be transferred
   * @param _data bytes Additional data with no specified format, sent in call to `_to`
   * @return true unless throwing
   */
  function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len, arg-overflow

  /**
   * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
   *  and then call `onApprovalReceived` on spender
   *  Beware that changing an allowance with this method brings the risk that someone may use both the old
   *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender address The address which will spend the funds
   * @param _value uint256 The amount of tokens to be spent
   */
  function approveAndCall(address _spender, uint256 _value) public returns (bool); // solium-disable-line max-len

  /**
   * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
   *  and then call `onApprovalReceived` on spender
   *  Beware that changing an allowance with this method brings the risk that someone may use both the old
   *  and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   *  race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   *  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender address The address which will spend the funds
   * @param _value uint256 The amount of tokens to be spent
   * @param _data bytes Additional data with no specified format, sent in call to `_spender`
   */
  function approveAndCall(address _spender, uint256 _value, bytes _data) public returns (bool); // solium-disable-line max-len
}

// File: erc-payable-token/contracts/token/ERC1363/ERC1363Receiver.sol

/**
 * @title ERC1363Receiver interface
 * @author Vittorio Minacori (https://github.com/vittominacori)
 * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
 *  from ERC1363 token contracts as defined in
 *  https://github.com/ethereum/EIPs/issues/1363
 */
contract ERC1363Receiver {
  /*
   * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
   * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
   */

  /**
   * @notice Handle the receipt of ERC1363 tokens
   * @dev Any ERC1363 smart contract calls this function on the recipient
   *  after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
   *  transfer. Return of other than the magic value MUST result in the
   *  transaction being reverted.
   *  Note: the contract address is always the message sender.
   * @param _operator address The address which called `transferAndCall` or `transferFromAndCall` function
   * @param _from address The address which are token transferred from
   * @param _value uint256 The amount of tokens transferred
   * @param _data bytes Additional data with no specified format
   * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
   *  unless throwing
   */
  function onTransferReceived(address _operator, address _from, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len, arg-overflow
}

// File: erc-payable-token/contracts/token/ERC1363/ERC1363Spender.sol

/**
 * @title ERC1363Spender interface
 * @author Vittorio Minacori (https://github.com/vittominacori)
 * @dev Interface for any contract that wants to support approveAndCall
 *  from ERC1363 token contracts as defined in
 *  https://github.com/ethereum/EIPs/issues/1363
 */
contract ERC1363Spender {
  /*
   * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
   * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
   */

  /**
   * @notice Handle the approval of ERC1363 tokens
   * @dev Any ERC1363 smart contract calls this function on the recipient
   *  after an `approve`. This function MAY throw to revert and reject the
   *  approval. Return of other than the magic value MUST result in the
   *  transaction being reverted.
   *  Note: the contract address is always the message sender.
   * @param _owner address The address which called `approveAndCall` function
   * @param _value uint256 The amount of tokens to be spent
   * @param _data bytes Additional data with no specified format
   * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
   *  unless throwing
   */
  function onApprovalReceived(address _owner, uint256 _value, bytes _data) external returns (bytes4); // solium-disable-line max-len
}

// File: erc-payable-token/contracts/token/ERC1363/ERC1363BasicToken.sol

// solium-disable-next-line max-len







/**
 * @title ERC1363BasicToken
 * @author Vittorio Minacori (https://github.com/vittominacori)
 * @dev Implementation of an ERC1363 interface
 */
contract ERC1363BasicToken is SupportsInterfaceWithLookup, StandardToken, ERC1363 { // solium-disable-line max-len
  using AddressUtils for address;

  /*
   * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
   * 0x4bbee2df ===
   *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
   *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
   *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
   *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
   */
  bytes4 internal constant InterfaceId_ERC1363Transfer = 0x4bbee2df;

  /*
   * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
   * 0xfb9ec8ce ===
   *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
   *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
   */
  bytes4 internal constant InterfaceId_ERC1363Approve = 0xfb9ec8ce;

  // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
  // which can be also obtained as `ERC1363Receiver(0).onTransferReceived.selector`
  bytes4 private constant ERC1363_RECEIVED = 0x88a7ca5c;

  // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
  // which can be also obtained as `ERC1363Spender(0).onApprovalReceived.selector`
  bytes4 private constant ERC1363_APPROVED = 0x7b04a2d0;

  constructor() public {
    // register the supported interfaces to conform to ERC1363 via ERC165
    _registerInterface(InterfaceId_ERC1363Transfer);
    _registerInterface(InterfaceId_ERC1363Approve);
  }

  function transferAndCall(
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    return transferAndCall(_to, _value, "");
  }

  function transferAndCall(
    address _to,
    uint256 _value,
    bytes _data
  )
    public
    returns (bool)
  {
    require(transfer(_to, _value));
    require(
      checkAndCallTransfer(
        msg.sender,
        _to,
        _value,
        _data
      )
    );
    return true;
  }

  function transferFromAndCall(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    // solium-disable-next-line arg-overflow
    return transferFromAndCall(_from, _to, _value, "");
  }

  function transferFromAndCall(
    address _from,
    address _to,
    uint256 _value,
    bytes _data
  )
    public
    returns (bool)
  {
    require(transferFrom(_from, _to, _value));
    require(
      checkAndCallTransfer(
        _from,
        _to,
        _value,
        _data
      )
    );
    return true;
  }

  function approveAndCall(
    address _spender,
    uint256 _value
  )
    public
    returns (bool)
  {
    return approveAndCall(_spender, _value, "");
  }

  function approveAndCall(
    address _spender,
    uint256 _value,
    bytes _data
  )
    public
    returns (bool)
  {
    approve(_spender, _value);
    require(
      checkAndCallApprove(
        _spender,
        _value,
        _data
      )
    );
    return true;
  }

  /**
   * @dev Internal function to invoke `onTransferReceived` on a target address
   *  The call is not executed if the target address is not a contract
   * @param _from address Representing the previous owner of the given token value
   * @param _to address Target address that will receive the tokens
   * @param _value uint256 The amount mount of tokens to be transferred
   * @param _data bytes Optional data to send along with the call
   * @return whether the call correctly returned the expected magic value
   */
  function checkAndCallTransfer(
    address _from,
    address _to,
    uint256 _value,
    bytes _data
  )
    internal
    returns (bool)
  {
    if (!_to.isContract()) {
      return false;
    }
    bytes4 retval = ERC1363Receiver(_to).onTransferReceived(
      msg.sender, _from, _value, _data
    );
    return (retval == ERC1363_RECEIVED);
  }

  /**
   * @dev Internal function to invoke `onApprovalReceived` on a target address
   *  The call is not executed if the target address is not a contract
   * @param _spender address The address which will spend the funds
   * @param _value uint256 The amount of tokens to be spent
   * @param _data bytes Optional data to send along with the call
   * @return whether the call correctly returned the expected magic value
   */
  function checkAndCallApprove(
    address _spender,
    uint256 _value,
    bytes _data
  )
    internal
    returns (bool)
  {
    if (!_spender.isContract()) {
      return false;
    }
    bytes4 retval = ERC1363Spender(_spender).onApprovalReceived(
      msg.sender, _value, _data
    );
    return (retval == ERC1363_APPROVED);
  }
}

// File: eth-token-recover/contracts/TokenRecover.sol

/**
 * @title TokenRecover
 * @author Vittorio Minacori (https://github.com/vittominacori)
 * @dev Allow to recover any ERC20 sent into the contract for error
 */
contract TokenRecover is Ownable {

  /**
   * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
   * @param _tokenAddress address The token contract address
   * @param _tokens Number of tokens to be sent
   * @return bool
   */
  function recoverERC20(
    address _tokenAddress,
    uint256 _tokens
  )
  public
  onlyOwner
  returns (bool success)
  {
    return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
  }
}

// File: contracts/token/base/BaseToken.sol

// solium-disable-next-line max-len
contract BaseToken is DetailedERC20, MintableToken, BurnableToken, ERC1363BasicToken, TokenRecover {

  modifier canTransfer() {
    require(
      mintingFinished,
      "Minting should be finished before transfer."
    );
    _;
  }

  constructor(string _name, string _symbol, uint8 _decimals)
  DetailedERC20(_name, _symbol, _decimals)
  public
  {}

  function transfer(
    address _to,
    uint256 _value
  )
  public
  canTransfer
  returns (bool)
  {
    return super.transfer(_to, _value);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
  public
  canTransfer
  returns (bool)
  {
    return super.transferFrom(_from, _to, _value);
  }
}

// File: contracts/token/FriendsFingersToken.sol

/**
 * @title FriendsFingersToken
 */
contract FriendsFingersToken is BaseToken {

  address public builder;

  constructor(
    string _name,
    string _symbol,
    uint8 _decimals
  )
    public
    BaseToken (_name, _symbol, _decimals)
  {
    builder = owner;
  }
}

// File: contracts/crowdsale/FriendsFingersCrowdsale.sol

// solium-disable-next-line max-len

// solium-disable-next-line max-len

// solium-disable-next-line max-len




/**
 * @title FriendsFingersCrowdsale
 */
// solium-disable-next-line max-len
contract FriendsFingersCrowdsale is CappedCrowdsale, FinalizableCrowdsale, MintedCrowdsale, Pausable, TokenRecover {

  enum State { Active, Refunding, Closed, Blocked, Expired }

  uint256 public id;
  uint256 public previousRoundId;
  uint256 public nextRoundId;

  // The token being sold
  FriendsFingersToken public token;

  // the round of crowdsale
  uint256 public round;

  // minimum amount of funds to be raised in weis
  uint256 public goal;

  string public crowdsaleInfo;

  uint256 public friendsFingersRatePerMille;
  address public friendsFingersWallet;

  uint256 public investorCount = 0;
  mapping (address => uint256) public deposited;
  State public state;

  event Closed();
  event Expired();
  event RefundsEnabled();
  event Refunded(address indexed beneficiary, uint256 weiAmount);

  constructor(
    uint256 _id,
    uint256 _cap,
    uint256 _goal,
    uint256 _openingTime,
    uint256 _closingTime,
    uint256 _rate,
    address _wallet,
    FriendsFingersToken _token,
    string _crowdsaleInfo,
    uint256 _round,
    uint256 _previousRoundId,
    uint256 _friendsFingersRatePerMille,
    address _friendsFingersWallet
  )
    public
    CappedCrowdsale (_cap)
    TimedCrowdsale (_openingTime, _closingTime)
    FinalizableCrowdsale ()
    Crowdsale (_rate, _wallet, _token)
  {
    require(
      _closingTime <= _openingTime + 30 days,
      "Crowdale must end in 30 days"
    );

    require(
      _round <= 5,
      "Can't restart more than 5 times"
    );

    if (_round == 1) {
      if (_id == 1) {
        require(
          _goal >= 0,
          "Goal must be greater or equal to zero"
        );
      } else {
        require(
          _goal > 0,
          "Goal must be greater than zero"
        );
      }
    } else {
      require(
        _goal == 0,
        "Goal must be equal to zero"
      );
    }
    require(
      _cap > 0,
      "Cap must be greater than zero"
    );
    require(
      _cap >= _goal,
      "Cap must be greater than goal"
    );

    goal = _goal;

    crowdsaleInfo = _crowdsaleInfo;

    token = _token;

    round = _round;
    previousRoundId = _previousRoundId;
    state = State.Active;

    id = _id;

    friendsFingersRatePerMille = _friendsFingersRatePerMille;
    friendsFingersWallet = _friendsFingersWallet;
  }

  // low level token purchase function
  function buyTokens(address _beneficiary) public whenNotPaused payable {
    uint256 weiAmount = msg.value;
    _preValidatePurchase(_beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _getTokenAmount(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    super._processPurchase(_beneficiary, tokens);
    emit TokenPurchase(
      msg.sender,
      _beneficiary,
      weiAmount,
      tokens
    );

    _updatePurchasingState(_beneficiary, weiAmount);

    _forwardFunds();
    _postValidatePurchase(_beneficiary, weiAmount);
  }

  // Public methods

  // if crowdsale is unsuccessful or blocked, investors can claim refunds here
  function claimRefund() public whenNotPaused {
    require(
      state == State.Refunding || state == State.Blocked,
      "State must be Refunding or Blocked"
    );
    address investor = msg.sender;

    uint256 depositedValue = deposited[investor];
    deposited[investor] = 0;
    investor.transfer(depositedValue);
    emit Refunded(investor, depositedValue);
  }

  function finalize() public whenNotPaused {
    super.finalize();
  }

  // View methods

  function goalReached() public view returns (bool) {
    return weiRaised >= goal;
  }

  /**
   * @dev Checks whether the period in which the crowdsale is open has already elapsed or cap reached
   * @return Whether crowdsale period has elapsed
   */
  function hasClosed() public view returns (bool) {
    return capReached() || super.hasClosed();
  }

  // Only owner methods

  function updateCrowdsaleInfo(string _crowdsaleInfo) public onlyOwner {
    require(!hasClosed(), "Crowdsale must not to be closed");
    crowdsaleInfo = _crowdsaleInfo;
  }

  function blockCrowdsale() public onlyOwner {
    require(state == State.Active, "State must be Active");
    state = State.Blocked;
  }

  function setnextRoundId(uint256 _nextRoundId) public onlyOwner {
    nextRoundId = _nextRoundId;
  }

  function setFriendsFingersRate(
    uint256 _newFriendsFingersRatePerMille
  )
    public
    onlyOwner
  {
    require(
      _newFriendsFingersRatePerMille >= 0,
      "Can't set a value less than zero"
    );
    require(
      _newFriendsFingersRatePerMille <= friendsFingersRatePerMille,
      "Can't set a value greater than the previous"
    );
    friendsFingersRatePerMille = _newFriendsFingersRatePerMille;
  }

  function setFriendsFingersWallet(
    address _friendsFingersWallet
  )
    public
    onlyOwner
  {
    require(
      _friendsFingersWallet != address(0),
      "Can't be set to the zero wallet"
    );
    friendsFingersWallet = _friendsFingersWallet;
  }

  // Emergency methods

  function safeWithdrawal() public onlyOwner {
    // solium-disable-next-line security/no-block-members
    require(
      block.timestamp >= closingTime + 365 days, // solium-disable-line security/no-block-members
      "Can't safe withdraw before than a year after the end"
    );
    friendsFingersWallet.transfer(address(this).balance);
  }

  function setExpiredAndWithdraw() public onlyOwner {
    // solium-disable-next-line security/no-block-members
    require(
      block.timestamp >= closingTime + 365 days, // solium-disable-line security/no-block-members
      "Can't withdraw before than a year after the end"
    );
    require(
      state == State.Refunding || state == State.Blocked,
      "Can't withdraw when Refunding or Blocked"
    );
    state = State.Expired;
    friendsFingersWallet.transfer(address(this).balance);
    emit Expired();
  }

  // Internal methods

  // overriding CappedCrowdsale#_preValidatePurchase to add extra cap logic
  // @return true if investors can buy at the moment
  function _preValidatePurchase(
    address _beneficiary,
    uint256 _weiAmount
  )
    internal
  {
    require(state == State.Active, "State must be Active");
    super._preValidatePurchase(_beneficiary, _weiAmount);
  }

  // We're overriding the fund forwarding from Crowdsale.
  function _forwardFunds() internal {
    if (deposited[msg.sender] == 0) {
      investorCount++;
    }
    deposited[msg.sender] = deposited[msg.sender].add(msg.value);
  }

  // vault finalization task, called when owner calls finalize()
  function finalization() internal {
    require(state == State.Active, "State must be Active");

    if (goalReached()) {
      state = State.Closed;
      emit Closed();

      if (friendsFingersRatePerMille > 0) {
        uint256 friendsFingersFee = weiRaised.mul(friendsFingersRatePerMille).div(1000);
        friendsFingersWallet.transfer(friendsFingersFee);
      }

      wallet.transfer(address(this).balance);
    } else {
      state = State.Refunding;
      emit RefundsEnabled();
    }

    if (friendsFingersRatePerMille > 0) {
      uint256 friendsFingersSupply = cap.mul(rate).mul(friendsFingersRatePerMille).div(1000);
      token.mint(owner, friendsFingersSupply);
    }

    token.transferOwnership(owner);

    super.finalization();
  }

}
