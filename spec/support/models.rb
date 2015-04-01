class User < ActiveRecord::Base
  scoped_enum :role,
              { normal: 0, administrator: 1, superuser: 2 },
              { manager: [:administrator, :superuser] }
  def self.non_superusers
  end

  def higher_position?
  end
end