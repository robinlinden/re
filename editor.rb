#!/usr/bin/env ruby

require "io/console"

class Editor
    def initialize
        @lines = File.readlines("test.txt").map do |line|
            line.sub(/\n$/, "")
        end
    end

    def run
        IO.console.raw do
            loop do
                render
                handle_input
            end
        end
    end

    def render
        ANSI.clear_screen
        ANSI.move_cursor(0, 0)
        p @lines
    end

    def handle_input
        key = $stdin.getc
        case key
        when "\C-x" then exit(0)
        end
    end
end

class ANSI
    def self.clear_screen
        $stdout.write("\e[2J")
    end

    def self.move_cursor(row, col)
        $stdout.write("\e[#{row + 1};#{col + 1}H")
    end
end

Editor.new.run
