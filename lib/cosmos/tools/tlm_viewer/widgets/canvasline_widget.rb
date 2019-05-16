# encoding: ascii-8bit

# Copyright 2014 Ball Aerospace & Technologies Corp.
# All Rights Reserved.
#
# This program is free software; you can modify and/or redistribute it
# under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 3 with
# attribution addendums as found in the LICENSE.txt

require 'cosmos/tools/tlm_viewer/widgets/widget'

module Cosmos
  class CanvaslineWidget
    include Widget

    def is_numeric?(obj)
      obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

    def initialize(parent_layout, x1, y1, x2, y2, color = 'black', width = 1, connector = 'NO_CONNECTOR')
      super()
      @xe1 = x1
      @ye1 = y1
      @xe2 = x2
      @ye2 = y2
      @width = width.to_i
      if connector.to_s.upcase == 'CONNECTOR'
        @connector = true
      else
        @connector = false
      end
      @color = Cosmos::getColor(color)
      @pen = Cosmos.getPen(color)
      upate_line
      parent_layout.add_repaint(self)
    end

    def eval_value(string_or_numeric)
      if is_numeric?(string_or_numeric)
        return value.to_i
      else
          return @screen.instance_eval(string_or_numeric.to_s)
      end
    end

    def upate_line
        @x1 = eval_value(@xe1)
        @y1 = eval_value(@ye1)
        @x2 = eval_value(@xe2)
        @y2 = eval_value(@ye2)
        @width = eval_value(@widthe)
    end

    def paint(painter)
      painter.save
      @pen.setWidth(@width)
      painter.setPen(@pen)
      painter.drawLine(@x1, @y1, @x2, @y2)
      painter.drawLine(@x1, @y1, @x2, @y2)
      if (@connector == true)
        painter.setBrush(@color)
        painter.drawEllipse(@point, @width, @width)
      end
      painter.restore
    end

    def update_widget
      update_line
    end

    def dispose
      super()
      @point.dispose
    end
  end
end
