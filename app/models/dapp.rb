class Dapp < ApplicationRecord
  include VersionControlConcern

  validates :ios_version, presence: true
  validates :android_version, presence: true

  belongs_to :dapp_type

  scope :default_order, -> { order(updated_at: :desc) }

  enum d_type: {
    new_dapp: 10,
    popular: 20,
    exchange: 30,
  }

end
