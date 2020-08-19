# encoding: ascii-8bit

# Copyright 2014 Ball Aerospace & Technologies Corp.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt

# This file contains the implementation of the ArrayDataObjectAdder
# This provides a quick way to add array data objects.

require 'cosmos'
require 'cosmos/tools/tlm_grapher/data_object_adders/xy_data_object_adder'

module Cosmos

  # Widget for adding a X-Y data object to a plot
  class ArrayDataObjectAdder < XyDataObjectAdder
    def add_data_object
      data_object = ArrayDataObject.new
      data_object.target_name = @telemetry_chooser.target_name
      data_object.packet_name = @telemetry_chooser.packet_name
      data_object.y_item_name = @telemetry_chooser.item_name
      data_object.x_item_name = @x_item_name.string

      @add_data_object_callback.call(data_object) if @add_data_object_callback
    end
  end
end
