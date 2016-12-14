module PagarMe
  class NestedModel < Model
    PARENT_ID_MUST_BE_INFORMED = 'Parent ID must be informed'.freeze

    attr_accessor :parent_id

    def initialize(hash = Hash.new)
      hash = hash.dup
      @parent_id = hash.delete(:parent_id) || hash.delete('parent_id')
      super hash
    end

    def create
      update PagarMe::Request.post(self.class.url(parent_id), params: to_hash).run
      self
    end

    def url(*params)
      raise IdMustBeInformedError.new unless id.present?
      self.class.url parent_id, CGI.escape(id.to_s), *params
    end

    class << self

      def parent_resource_name
        raise NotImplementedError
      end

      def find_by_id(parent_id, id)
        raise IdMustBeInformedError.new                    unless        id.present?
        raise RequestError.new(PARENT_ID_MUST_BE_INFORMED) unless parent_id.present?

        object = PagarMe::Request.get(url parent_id, id).call
        if object
          object.parent_id = parent_id
        end
        object
      end
      alias :find :find_by_id

      def find_by(parent_id, params = Hash.new, page = nil, count = nil)
        params = extract_page_count_or_params(page, count, **params)
        raise RequestError.new('Invalid page count') if params[:page] < 1 or params[:count] < 1

        PagarMe::Request.get(url(parent_id), params: params).call.map do |object|
          object.parent_id = parent_id
          object
        end
      end
      alias :find_by_hash :find_by

      def all(parent_id, *args, **params)
        params = extract_page_count_or_params(*args, **params)
        find_by parent_id, params
      end

      def url(parent_id, *params)
        raise RequestError.new(PARENT_ID_MUST_BE_INFORMED) unless parent_id.present?
        ["/#{parent_resource_name}", parent_id, "#{ CGI.escape underscored_class_name }s", *params].join '/'
      end

    end
  end
end
