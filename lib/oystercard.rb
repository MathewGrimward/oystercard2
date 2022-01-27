class Oystercard
  attr_reader :balance, :entry_station, :exit_station, :journeys

  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_CHARGE = 1
  

  def initialize
    @balance = 0
    @journeys = []
  end

  def top_up(balance)
    fail "Maximum balance of #{MAX_BALANCE} was exceeded" if @balance + balance > MAX_BALANCE
    @balance += balance
  end

  def spend(balance)
    @balance -= balance
  end

  def in_journey?
    @entry_station
  end

  def touch_in(entry_station)
    fail "Insufficient balance to touch in" if @balance < MIN_BALANCE
    @entry_station = entry_station
    @journeys << { :entry => entry_station, :exit => exit_station }
  end

  def touch_out(exit_station)
    deduct
    @exit_station = exit_station
    @journeys [-1][:exit] = exit_station
    @entry_station = nil
  end

private

  def deduct
    @balance -= MIN_CHARGE
  end
end

