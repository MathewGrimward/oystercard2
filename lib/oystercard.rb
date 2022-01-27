class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_CHARGE = 1
  
  attr_reader :balance, :entry_station

  def initialize
    @balance = 0
    @in_journey = false
    @entry_station = nil
  end

  def top_up(balance)
    fail "Maximum balance of #{MAX_BALANCE} was exceeded" if @balance + balance > MAX_BALANCE
    @balance += balance
  end

  def spend(balance)
    @balance -= balance
  end

  def in_journey?
    @entry_station != nil
    #@in_journey
  end

  def touch_in(entry_station)
    fail "Insufficient funds to touch in" if @balance < MIN_BALANCE
    @in_journey = true
    @entry_station = entry_station
  end

  def touch_out
    deduct
    @in_journey = false
  end

private

  def deduct
    @balance -= MIN_CHARGE
  end
end