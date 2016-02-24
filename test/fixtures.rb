class Fixtures
  def transaction
    { amount: 1000 }
  end

  def boleto
    { payment_method: 'boleto' }
  end

  def transfer
    { amount: 1000 }
  end

  def card
    {
      card_number:           '4901720080344448',
      card_holder_name:      'Jose da Silva',
      card_expiration_month: '10',
      card_expiration_year:  valid_expiration_year,
      card_cvv:              '314'
    }
  end

  def split_rule(recipient_id, percentage)
    { recipient_id: recipient_id, percentage: percentage }
  end

  def split_rules
    {
      split_rules: [
        split_rule(persistent_recipient_ids[0], 10),
        split_rule(persistent_recipient_ids[1], 20),
        split_rule(persistent_recipient_ids[2], 30),
        split_rule(persistent_recipient_ids[3], 40)
      ]
    }
  end

  def invalid_split_rules
    {
      split_rules: [
        { percentage: 10 },
        split_rule(persistent_recipient_ids[1], 20),
        split_rule(persistent_recipient_ids[2], 30),
        split_rule(persistent_recipient_ids[3], 40)
      ]
    }
  end

  def refused_card
    # In test environment CVV's that starts with digit 6 are refused by acquirer
    card.merge card_cvv: '600'
  end

  def plan
    {
      days:       30,
      name:       'Plano gold',
      amount:     3000,
      trial_days: 5
    }
  end

  def other_plan
    {
      name:   'Plano Silver',
      days:   30,
      amount: 3000
    }
  end

  def bank_account
    {
      bank_code:       '237',
      agencia:         '1935',
      agencia_dv:      '9',
      conta:           '23398',
      conta_dv:        '9',
      legal_name:      'foo bar loem',
      document_number: '00000000000000'
    }
  end

  def nested_bank_account
    { bank_account: bank_account }
  end

  def refund_bank_account
    {
      bank_account: {
        bank_code:       '399',
        agencia:         '1234',
        conta:           '1234567',
        conta_dv:        '1',
        legal_name:      'Jose da Silva',
        document_number: '68782915423'
      }
    }
  end

  def recipient
    {
      transfer_day:      3,
      transfer_enabled:  true,
      transfer_interval: 'daily'
    }
  end

  def postback
    { postback_url: 'http://test.com/postback' }
  end

  def subscription
    card.merge customer: { email: 'customer@pagar.me' }
  end

  def customer
    {
      customer: {
        name:            'Jose da Silva',
        document_number: '36433809847',
        email:           'henrique+test@pagar.me',
        gender:          'M',
        born_at:         '1970-10-11',
        phone:           { ddd: '12', number: '981433533' },
        address: {
          street:        'Av. Brigadeiro Faria Lima',
          neighborhood:  'Itaim bibi',
          zipcode:       '01452000',
          street_number: '2941'
        }
      }
    }
  end

  def invalid_expiration_year
    { card_expiration_year: _invalid_expiration_year }
  end

  def respond_to?(method_name)
    return true if super(method_name)
    method_name.to_s.split(/_with_/).all?{ |m| super(m) }
  end

  def valid_expiration_year
    ( Time.now.year+1 ).to_s[2..-1]
  end

  def persistent_recipient_ids
    VCR.use_cassette('fixtures/persistent_recipients') do
      4.times.map do
        PagarMe::Recipient.create(recipient_with_nested_bank_account).id
      end
    end
  end

  def self.persistent_recipient_ids
    new.persistent_recipient_ids
  end

  protected

  def _invalid_expiration_year
    ( Time.now.year-1 ).to_s[2..-1]
  end

  def method_missing(name, *args, &block)
    if respond_to?(name)
      name.to_s.split(/_with_/).map{ |m| public_send m }.inject Hash.new, &:merge
    else
      super name, *args, &block
    end
  end

  module Helpers
    protected
    def fixtures
      @fixtures ||= Fixtures.new
    end

    def method_missing(name, *args, &block)
      match = name.to_s.match /\_params\Z/
      if match && fixtures.respond_to?(match.pre_match) && args.count < 2
        if args.empty?
          fixtures.public_send match.pre_match
        else
          fixtures.public_send(match.pre_match).merge args.first
        end
      else
        super name, *args, &block
      end
    end
  end
end
