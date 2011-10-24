# -*- encoding: utf-8 -*-
require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'test/unit'
require 'shoulda'

require 'simplecov'
require 'yajl'
require 'mrapper'

SimpleCov.start

unless Kernel.const_defined?("MONGODB_MR_RESULT")
  MONGODB_MR_RESULT1 = {
    :cached=>true,
    :result=>[
      {"_id"=>{"campaign_product"=>"blockheizkraftwerk"},     "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"erdwaermepumpe"},         "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"fenster"},                "value"=>{"conversions"=>36,  "cost"=>486.74,   "impressions"=>125732, "cr"=>6.91, "cpa"=>13.52, "clicks"=>521}},
      {"_id"=>{"campaign_product"=>"gabelstapler"},           "value"=>{"conversions"=>40,  "cost"=>1634.05,  "impressions"=>760774, "cr"=>2.89, "cpa"=>40.85, "clicks"=>1382}},
      {"_id"=>{"campaign_product"=>"garage"},                 "value"=>{"conversions"=>15,  "cost"=>229.54,   "impressions"=>434840, "cr"=>5.14, "cpa"=>15.3, "clicks"=>292}},
      {"_id"=>{"campaign_product"=>"haustueren"},             "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"inkasso"},                "value"=>{"conversions"=>6,   "cost"=>203.14,   "impressions"=>82691, "cr"=>4.05, "cpa"=>33.86, "clicks"=>148}},
      {"_id"=>{"campaign_product"=>"kaffeeautomaten"},        "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"kaltgetraenkeautomaten"}, "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"kopierer"},               "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"käuferportal"},           "value"=>{"conversions"=>1,   "cost"=>1.87,     "impressions"=>155, "cr"=>2.5, "cpa"=>1.87, "clicks"=>40}},
      {"_id"=>{"campaign_product"=>"lohnabrechnung"},         "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"luftwärmepumpe"},         "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"plotter"},                "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"solaranlagen"},           "value"=>{"conversions"=>151, "cost"=>2523.09,  "impressions"=>3868089, "cr"=>3.35, "cpa"=>16.71, "clicks"=>4510}},
      {"_id"=>{"campaign_product"=>"telefonanlagen"},         "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"treppenlift"},            "value"=>{"conversions"=>19,  "cost"=>1822.02,  "impressions"=>329370, "cr"=>6.35, "cpa"=>95.9, "clicks"=>299}},
      {"_id"=>{"campaign_product"=>"videoproduktionen"},      "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"waermebildkamera"},       "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"wasserspender"},          "value"=>{"conversions"=>17,  "cost"=>316.28,   "impressions"=>123158, "cr"=>7.83, "cpa"=>18.6, "clicks"=>217}},
      {"_id"=>{"campaign_product"=>"webdesign"},              "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>0, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}},
      {"_id"=>{"campaign_product"=>"wintergarten"},           "value"=>{"conversions"=>0,   "cost"=>0.0,      "impressions"=>11, "cr"=>0.0, "cpa"=>0.0, "clicks"=>0}}
    ]
  }

  MONGODB_MR_RESULT2 = {
    :cached=>true,
    :result=>[
      {"_id"=>{"campaign_product"=>"blockheizkraftwerk"},     "value"=>{"conversions"=>10,  "cost"=>0.0,  "impressions"=>1000,  "cr"=>0.11, "cpa"=>1.01,  "clicks"=>111}},
      {"_id"=>{"campaign_product"=>"erdwaermepumpe"},         "value"=>{"conversions"=>20,  "cost"=>1.0,  "impressions"=>2000,  "cr"=>0.22, "cpa"=>2.01,  "clicks"=>222}},
      {"_id"=>{"campaign_product"=>"fenster"},                "value"=>{"conversions"=>30,  "cost"=>2.0,  "impressions"=>3000,  "cr"=>0.33, "cpa"=>3.01,  "clicks"=>333}},
      {"_id"=>{"campaign_product"=>"gabelstapler"},           "value"=>{"conversions"=>40,  "cost"=>3.0,  "impressions"=>4000,  "cr"=>0.44, "cpa"=>4.01,  "clicks"=>444}},
      {"_id"=>{"campaign_product"=>"garage"},                 "value"=>{"conversions"=>50,  "cost"=>4.0,  "impressions"=>5000,  "cr"=>0.55, "cpa"=>5.01,  "clicks"=>555}},
      {"_id"=>{"campaign_product"=>"haustueren"},             "value"=>{"conversions"=>60,  "cost"=>5.0,  "impressions"=>6000,  "cr"=>0.66, "cpa"=>6.01,  "clicks"=>666}},
      {"_id"=>{"campaign_product"=>"inkasso"},                "value"=>{"conversions"=>70,  "cost"=>6.0,  "impressions"=>7000,  "cr"=>0.77, "cpa"=>7.01,  "clicks"=>777}},
      {"_id"=>{"campaign_product"=>"kaffeeautomaten"},        "value"=>{"conversions"=>80,  "cost"=>7.0,  "impressions"=>8000,  "cr"=>0.88, "cpa"=>8.01,  "clicks"=>888}},
      {"_id"=>{"campaign_product"=>"kaltgetraenkeautomaten"}, "value"=>{"conversions"=>90,  "cost"=>8.0,  "impressions"=>9000,  "cr"=>0.99, "cpa"=>9.01,  "clicks"=>999}},
      {"_id"=>{"campaign_product"=>"kopierer"},               "value"=>{"conversions"=>100, "cost"=>9.0,  "impressions"=>10000, "cr"=>1.11, "cpa"=>10.01, "clicks"=>1110}},
      {"_id"=>{"campaign_product"=>"käuferportal"},           "value"=>{"conversions"=>110, "cost"=>11.0, "impressions"=>11000, "cr"=>1.22, "cpa"=>11.01, "clicks"=>1221}},
      {"_id"=>{"campaign_product"=>"lohnabrechnung"},         "value"=>{"conversions"=>120, "cost"=>12.0, "impressions"=>12000, "cr"=>1.33, "cpa"=>12.01, "clicks"=>1332}},
      {"_id"=>{"campaign_product"=>"luftwärmepumpe"},         "value"=>{"conversions"=>130, "cost"=>13.0, "impressions"=>13000, "cr"=>1.44, "cpa"=>13.01, "clicks"=>1443}},
      {"_id"=>{"campaign_product"=>"plotter"},                "value"=>{"conversions"=>140, "cost"=>14.0, "impressions"=>14000, "cr"=>1.55, "cpa"=>14.01, "clicks"=>1554}},
      {"_id"=>{"campaign_product"=>"solaranlagen"},           "value"=>{"conversions"=>150, "cost"=>15.0, "impressions"=>15000, "cr"=>1.66, "cpa"=>15.01, "clicks"=>1665}},
      {"_id"=>{"campaign_product"=>"telefonanlagen"},         "value"=>{"conversions"=>160, "cost"=>16.0, "impressions"=>16000, "cr"=>1.77, "cpa"=>16.01, "clicks"=>1776}},
      {"_id"=>{"campaign_product"=>"treppenlift"},            "value"=>{"conversions"=>170, "cost"=>17.0, "impressions"=>17000, "cr"=>1.88, "cpa"=>17.01, "clicks"=>1887}},
      {"_id"=>{"campaign_product"=>"videoproduktionen"},      "value"=>{"conversions"=>180, "cost"=>18.0, "impressions"=>18000, "cr"=>1.99, "cpa"=>18.01, "clicks"=>1998}},
      {"_id"=>{"campaign_product"=>"waermebildkamera"},       "value"=>{"conversions"=>190, "cost"=>19.0, "impressions"=>19000, "cr"=>2.11, "cpa"=>19.01, "clicks"=>2109}},
      {"_id"=>{"campaign_product"=>"wasserspender"},          "value"=>{"conversions"=>200, "cost"=>21.0, "impressions"=>20000, "cr"=>2.22, "cpa"=>20.01, "clicks"=>2220}},
      {"_id"=>{"campaign_product"=>"webdesign"},              "value"=>{"conversions"=>210, "cost"=>22.0, "impressions"=>21000, "cr"=>2.33, "cpa"=>21.01, "clicks"=>2331}},
      {"_id"=>{"campaign_product"=>"wintergarten"},           "value"=>{"conversions"=>220, "cost"=>23.0, "impressions"=>22000, "cr"=>2.44, "cpa"=>22.01, "clicks"=>2442}}
    ]
  }

  MODEL_MONDGODB_RESULT_EMIT_KEY_KEYS = [{:key=>:campaign_product, :formatted_key=>"campaign_product"}]
  MODEL_MONDGODB_RESULT_EMIT_VALUE_KEYS =
    [ {:key=>:conversions, :formatted_key=>"conversions"},
      {:key=>:cost, :formatted_key=>"cost"},
       {:key=>:impressions, :formatted_key=>"impressions"},
       {:key=>:cr, :formatted_key=>"cr"},
       {:key=>:cpa, :formatted_key=>"cpa"},
       {:key=>:clicks, :formatted_key=>"clicks"}]

  MODEL_MONGODB_RESULT_FIRST_ROW =
      {
        :mr_emit_keys=>[
          {:key=>:campaign_product,
           :value=>"blockheizkraftwerk",
           :formatted_key=>"campaign_product",
           :formatted_value=>"blockheizkraftwerk",
           :css=>{}
          }],
        :mr_emit_values=>[
          {:key=>:conversions,
           :value=>0,
           :formatted_key=>"conversions",
           :formatted_value=>0,
           :css=>{}
          },
          {:key=>:cost,
           :value=>0.0,
           :formatted_key=>"cost",
           :formatted_value=>0.0,
           :css=>{}
          },
          {:key=>:impressions,
           :value=>0,
           :formatted_key=>"impressions",
           :formatted_value=>0,
           :css=>{}
          },
          {:key=>:cr,
           :value=>0.0,
           :formatted_key=>"cr",
           :formatted_value=>0.0,
           :css=>{}
          },
          {:key=>:cpa,
           :value=>0.0,
           :formatted_key=>"cpa",
           :formatted_value=>0.0,
           :css=>{}
          },
          {:key=>:clicks,
           :value=>0,
           :formatted_key=>"clicks",
           :formatted_value=>0,
           :css=>{}
          }
        ],
      :bollinger=>""
      }

  MODEL_MONGODB_RESULT_FIRST_ROW_KEYS =
    [{:key=>:campaign_product,
      :value=>"blockheizkraftwerk",
      :formatted_key=>"campaign_product",
      :formatted_value=>"blockheizkraftwerk",
      :css=>{}}]

  MODEL_MONGODB_RESULT_FIRST_ROW_VALUES =
     [{:key=>:conversions,  :value=>0,    :formatted_key=>"conversions",  :formatted_value=>0,    :css=>{}},
      {:key=>:cost,         :value=>0.0,  :formatted_key=>"cost",         :formatted_value=>0.0,  :css=>{}},
      {:key=>:impressions,  :value=>0,    :formatted_key=>"impressions",  :formatted_value=>0,    :css=>{}},
      {:key=>:cr,           :value=>0.0,  :formatted_key=>"cr",           :formatted_value=>0.0,  :css=>{}},
      {:key=>:cpa,          :value=>0.0,  :formatted_key=>"cpa",          :formatted_value=>0.0,  :css=>{}},
      {:key=>:clicks,       :value=>0,    :formatted_key=>"clicks",       :formatted_value=>0,    :css=>{}}]

  MONGODB_EMPTY_MR_RESULT =
      {:result => []}

  MODEL_MONGODB_EMPTY_MR_RESULT_METAINFORMATION = {:emit_key_keys=>[], :emit_value_keys=>[], :nr_rows=>0}
  MODEL_MONGODB_EMPTY_MR_RESULT_RESULT_ROWS = []
end

class Test::Unit::TestCase
  include Mrapper
  def check_merged_model(merged, was_merged_into, merge_columns)
    merge_columns.each do |merge_column|
      # iterate over all rows to check that we have merged (replaced) )conversions everywhere
      merged.result_rows.each_with_index do |merged_row, i|
        # get the corresponding row in the other model
        # there is also the method get_row, but for now we omit it
        # was_merged_into_row = @was_merged_into.get_row(merged_row, @merge_columns)
        was_merged_into_row = was_merged_into.result_rows[i]
        merged_col = was_merged_into_col = nil

        merged_row.mr_emit_values.each do |kv|
          if kv.key.eql?(merge_column)
            merged_col = kv
            break
          end
        end

        was_merged_into_row.mr_emit_values.each do |kv|
          if kv.key.eql?(merge_column)
            was_merged_into_col = kv
            break
          end
        end

        assert_equal was_merged_into_col.key, merged_col.key
        assert_equal was_merged_into_col.value, merged_col.value
      end
    end
  end
end
