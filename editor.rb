#!/usr/bin/env ruby

require "io/console"

class Editor
    def initialize
        lines = File.readlines("test.txt").map do |line|
            line.sub(/\n$/, "")
        end

        @buffer = Buffer.new(lines)
        @cursor = Cursor.new
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
        @buffer.render
        ANSI.move_cursor(@cursor.row, @cursor.col)
    end

    def handle_input
        key = $stdin.getc
        case key
        when "\C-x" then exit(0)
        when "\C-p" then @cursor = @cursor.up(@buffer)
        when "\C-n" then @cursor = @cursor.down(@buffer)
        when "\C-b" then @cursor = @cursor.left(@buffer)
        when "\C-f" then @cursor = @cursor.right(@buffer)
        else
            @buffer = @buffer.insert(key, @cursor.row, @cursor.col)
            @cursor = @cursor.right(@buffer)
        end
    end
end

class Buffer
    def initialize(lines)
        @lines = lines
    end

    def insert(char, row, col)
        lines = @lines.map(&:dup)
        lines.fetch(row).insert(col, char)
        Buffer.new(lines)
    end

    def render
        @lines.map do |line|
            $stdout.write(line)
            ANSI.cursor_next_line
        end
    end

    def line_count
        @lines.count
    end

    def line_length(row)
        @lines.fetch(row).length
    end
end

class Cursor
    attr_reader :row, :col

    def initialize(row=0, col=0)
        @row = row
        @col = col
    end

    def up(buffer)
        Cursor.new(@row - 1, @col).clamp(buffer)
    end

    def down(buffer)
        Cursor.new(@row + 1, @col).clamp(buffer)
    end

    def left(buffer)
        Cursor.new(@row, @col - 1).clamp(buffer)
    end

    def right(buffer)
        Cursor.new(@row, @col + 1).clamp(buffer)
    end

    def clamp(buffer)
        row = @row.clamp(0, buffer.line_count - 1)
        col = @col.clamp(0, buffer.line_length(row))
        Cursor.new(row, col)
    end
end

class ANSI
    def self.clear_screen
        $stdout.write("\e[2J")
    end

    def self.move_cursor(row, col)
        $stdout.write("\e[#{row + 1};#{col + 1}H")
    end

    def self.cursor_down(count=1)
        $stdout.write("\e[#{count}B")
    end

    def self.cursor_next_line(count=1)
        $stdout.write("\e[#{count}E")
    end
end

Editor.new.run
