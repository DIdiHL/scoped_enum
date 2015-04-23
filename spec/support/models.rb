class User < ActiveRecord::Base
  scoped_enum :role,
              [:normal, :administrator, :superuser],
              { manager: [:administrator, :superuser] } do |e|
    e.scope :non_admin, [:normal, :superuser]
  end

  def self.non_superusers
  end

  def higher_position?
  end
end