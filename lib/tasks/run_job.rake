task run_both: :environment do
  Nested::Testy.build_integer
  Tumby.build_integer
end

task run_nested: :environment do
  Nested::Testy.build_integer
end

task run_tumby: :environment do
  Tumby.build_integer
end
