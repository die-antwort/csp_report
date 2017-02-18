module CspReport
  class CspReport
    include Mongoid::Document
    include Mongoid::Timestamps
  
    field :document_uri, type: String
    field :referrer, type: String
    field :blocked_uri, type: String
    field :violated_directive, type: String
    field :original_policy, type: String
    field :incoming_ip, type: String
    field :edited_at, type: DateTime
    field :completed_at, type: DateTime

    validates_presence_of :document_uri, :violated_directive, :original_policy,
      :incoming_ip
  end
end
