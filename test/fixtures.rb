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

  def no_trial_plan
    {
      name:       'Plano Sem Trial',
      days:       30,
      amount:     3000,
      trial_days: 0
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
      transfer_interval: 'weekly'
    }
  end

  def postback
    { postback_url: 'http://test.com/postback' }
  end

  def postback_response
    {
      payload:   "id=406483&fingerprint=9e9496ef28d1154b2db9a446323db90103069330&event=transaction_status_changed&old_status=processing&desired_status=paid&current_status=paid&object=transaction&transaction[object]=transaction&transaction[status]=paid&transaction[refuse_reason]=null&transaction[status_reason]=acquirer&transaction[acquirer_response_code]=0&transaction[acquirer_name]=pagarme&transaction[authorization_code]=18051&transaction[soft_descriptor]=null&transaction[tid]=406483&transaction[nsu]=406483&transaction[date_created]=2016-03-03T19:13:31.000Z&transaction[date_updated]=2016-03-03T19:13:32.000Z&transaction[amount]=1000&transaction[authorized_amount]=1000&transaction[paid_amount]=1000&transaction[refunded_amount]=0&transaction[installments]=1&transaction[id]=406483&transaction[cost]=50&transaction[card_holder_name]=Jose da Silva&transaction[card_last_digits]=4448&transaction[card_first_digits]=490172&transaction[card_brand]=visa&transaction[postback_url]=http://example.com/postback/1&transaction[payment_method]=credit_card&transaction[capture_method]=ecommerce&transaction[antifraud_score]=null&transaction[boleto_url]=null&transaction[boleto_barcode]=null&transaction[boleto_expiration_date]=null&transaction[referer]=api_key&transaction[ip]=179.185.132.108&transaction[subscription_id]=null&transaction[phone][object]=phone&transaction[phone][ddi]=55&transaction[phone][ddd]=21&transaction[phone][number]=922334455&transaction[phone][id]=21123&transaction[address][object]=address&transaction[address][street]=Av. Brigadeiro Faria Lima&transaction[address][complementary]=null&transaction[address][street_number]=2941&transaction[address][neighborhood]=Itaim bibi&transaction[address][city]=São Paulo&transaction[address][state]=SP&transaction[address][zipcode]=1452000&transaction[address][country]=Brasil&transaction[address][id]=21810&transaction[customer][object]=customer&transaction[customer][document_number]=84931126235&transaction[customer][document_type]=cpf&transaction[customer][name]=Jose da Silva&transaction[customer][email]=pagarmetestruby@mailinator.com&transaction[customer][born_at]=1970-10-11T00:00:00.000Z&transaction[customer][gender]=M&transaction[customer][date_created]=2016-03-01T18:38:25.000Z&transaction[customer][id]=43304&transaction[card][object]=card&transaction[card][id]=card_cil9rcdql00gmbp6er9i5q48u&transaction[card][date_created]=2016-03-01T18:38:25.000Z&transaction[card][date_updated]=2016-03-01T18:38:29.000Z&transaction[card][brand]=visa&transaction[card][holder_name]=Jose da Silva&transaction[card][first_digits]=490172&transaction[card][last_digits]=4448&transaction[card][country]=BR&transaction[card][fingerprint]=F0Y0+wH0d8DS&transaction[card][customer]=undefined&transaction[card][valid]=true",
      signature: 'sha1=57925d5954efd85613bbffa121dc06b4e7737256'
    }
  end

  def subscription
    card.merge customer: { email: 'customer@pagar.me' }
  end

  def customer
    {
      customer: {
        name:            'Jose da Silva',
        document_number: '84931126235',
        email:           'pagarmetestruby@mailinator.com',
        gender:          'M',
        born_at:         '1970-10-11',
        phone:           { ddd: '21', number: '922334455' },
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

  def anticipations_limits
    {
      timeframe:    :end,
      payment_date: (Date.today + 7)
    }
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
      match = name.to_s.match(/\_params\Z/)
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
