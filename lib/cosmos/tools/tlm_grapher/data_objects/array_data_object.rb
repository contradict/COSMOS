# encoding: ascii-8bit

# Copyright 2014 Ball Aerospace & Technologies Corp.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt

require 'cosmos'
require 'cosmos/tools/tlm_grapher/data_objects/xy_data_object'

module Cosmos
  # Represents a data object on an XyGraph for two telemetry items
  class ArrayDataObject < XyDataObject
    VALUE_TYPES = [:RAW, :CONVERTED, :INDEX]
    # (see DataObject#process_packet)
    def process_packet(packet, count)
      begin
        if @x_value_type == :RAW
          x_value = packet.read(@x_item_name, :RAW)
        elsif @x_value_type == :CONVERTED
          x_value = packet.read(@x_item_name)
        end
        if @y_value_type == :RAW
          y_value = packet.read(@y_item_name, :RAW)
        elsif @y_value_type == :CONVERTED
          y_value = packet.read(@y_item_name)
        end

        if @x_value_type == :INDEX and @y_value_type == :INDEX
          x_value = %w[0 1 2 3 4]
          y_value = %w[2 2 9 2 1]
        elsif @x_value_type == :INDEX
          if not y_value.is_a?(Array)
            y_value = [y_value]
          end
          x_value = (0...y_value.count).to_a
        elsif @y_value_type == :INDEX
          if not x_value.is_a?(Array)
            x_value = [x_value]
          end
          y_value = (0...x_value.count).to_a
        end

        @x_values.clear
        @y_values.clear
        x_value.zip(y_value).each{ |x, y|
            if not (invalid_value?(x) || invalid_value?(y))
              @x_values << x
              @y_values << y
            end
        }

        time_value = packet.read(@time_item_name) if @time_item_name

        @time_values = [time_value] if @time_item_name

        @plot.redraw_needed = true

      rescue Exception => error
        handle_process_exception(error, "#{packet.target_name} #{packet.packet_name} #{@x_item_name} or #{@y_item_name}")
      end
    end # def process_packet
  end
end
