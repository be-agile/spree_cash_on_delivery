module SpreeCashOnDelivery::Spree::PaymentDecorator
  def build_source
    return unless new_record?

    if source_attributes.present? && source.blank? && payment_method.try(:payment_source_class)
      self.source = payment_method.payment_source_class.new(source_attributes)
      source.payment_method_id = payment_method.id
      source.user_id = order.user_id if order
    end
    
    # for Cash on Delivery
    if payment_method and payment_method.respond_to?(:post_create)
      payment_method.post_create(self)
    end

  end
end

Spree::Payment.prepend SpreeCashOnDelivery::Spree::PaymentDecorator unless Spree::Payment.included_modules.include?(SpreeCashOnDelivery::Spree::PaymentDecorator)