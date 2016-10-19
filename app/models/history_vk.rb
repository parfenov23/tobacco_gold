class HistoryVk < ActiveRecord::Base
	serialize :params_type, ActiveRecord::Coders::Hstore
end
