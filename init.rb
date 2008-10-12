ActiveRecord::Base.class_eval do
  def self.count_by_month(options = {})
    finder_sql = construct_finder_sql(options.merge(:select => %(strftime('%Y-%m', "#{table_name}"."created_at") as 'month', count("#{table_name}"."created_at") as "count"), :group => :month))
    returning({}) do |counts|
      connection.select_all(finder_sql).each do |row|
        counts[Date.strptime(row['month'], '%Y-%m')] = row['count'].to_i
      end
    end
  end
end
