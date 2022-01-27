require 'oystercard'

describe Oystercard do 
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }
  
  describe ':balance' do
    it 'has balance of 0 when initialized' do
      expect(subject.balance).to eq 0
    end
  end

  context 'topped up card' do
    before(:each) do
      subject.top_up(Oystercard::MAX_BALANCE)
    end

    it 'should top-up the balance' do
      expect(subject.balance).to eq Oystercard::MAX_BALANCE
    end

    it 'sets maximum limit on card - raises error' do
      expect{subject.top_up(1)}.to raise_error "Maximum balance of #{Oystercard::MAX_BALANCE} was exceeded"
    end

  end

  describe 'in journey' do

    it 'new card not in journey' do
      expect(subject).not_to be_in_journey
    end
  end

  context 'card touched in - balance greater than min' do
    before(:each) do
      subject.top_up(Oystercard::MAX_BALANCE)
      subject.touch_in(entry_station)
    end

    it 'is in journey after touch in' do
      expect(subject).to be_in_journey
    end

    it 'is not in journey after touch out' do
      subject.touch_out(exit_station)
      expect(subject).not_to be_in_journey 
    end

    it 'forgets entry station after touch out' do
      subject.touch_out(exit_station)
      expect(subject.entry_station).to eq nil
    end

    it 'deducts fare from balance after journey' do
      expect{ subject.touch_out(exit_station) }.to change { subject.balance }.by -Oystercard::MIN_CHARGE
    end

    it 'remembers entry station' do
      expect(subject.entry_station).to eq entry_station
    end
      
    it 'remembers exit station when touched out' do
      subject.touch_out(exit_station)
      expect(subject.exit_station).to eq exit_station
    end
  
  end

  context 'card below min balance' do
    it 'checks min balance on card for touch in' do
      expect { subject.touch_in(entry_station) }.to raise_error "Insufficient balance to touch in"
    end
  end

  context 'new card storing journeys' do
    before(:each) do
     subject.top_up(Oystercard::MAX_BALANCE)
    end

 it 'has an empty list of journeys by default' do
   expect(subject.journeys).to be_empty
 end

 it 'stores a journey' do
   subject.touch_in(entry_station)
   subject.touch_out(exit_station)
   expect(subject.journeys).to eq [:entry => entry_station, :exit => exit_station]
  end
end
 
end
  












  














  