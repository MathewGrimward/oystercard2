require 'oystercard'

describe Oystercard do

  let (:entry_station) {double :entry_station}

  it 'has a balance of zero' do
    expect(subject.balance).to eq(0)
    end

  it 'can be topped up' do
    expect{subject.top_up(10)}.to change {subject.balance}.by 10
    end

  it 'can reduce the balance' do
    expect{subject.spend(10)}.to change {subject.balance}.by -10
  end

  it 'is initially not in a journey' do
  expect(subject).not_to be_in_journey
  end

  it 'can check cards balance for sufficient funds' do
    expect{ subject.touch_in(entry_station) }.to raise_error "Insufficient funds to touch in" 
  end

  it 'can touch in' do
    subject.top_up(Oystercard::MIN_BALANCE)
    subject.touch_in(entry_station)
    expect(subject).to be_in_journey
  end

  it 'can touch out' do
    subject.top_up(Oystercard::MIN_BALANCE)
    subject.touch_out
    expect(subject).not_to be_in_journey
  end

  it 'can deducted fare on touch out' do
    expect{ subject.touch_out }.to change{ subject.balance }.by(subject.send(:deduct))
  end

  it 'can remember station after touch in' do
    subject.top_up(Oystercard::MIN_BALANCE)
    expect(subject.touch_in(entry_station)).to eq entry_station
  end

describe "change balance" do
    it 'raise an error if max balance is reached' do
    expect{ subject.top_up(Oystercard::MAX_BALANCE + 1) }.to raise_error("Maximum balance of #{Oystercard::MAX_BALANCE} was exceeded")
    end
  end
end