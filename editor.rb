#!/usr/bin/env ruby

class Editor
    def initialize
        lines = File.readlines("test.txt").map do |line|
            line.sub(/\n$/, "")
        end
        p lines
    end
end

Editor.new
