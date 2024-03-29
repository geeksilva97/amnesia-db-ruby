module Amnesia::Support
  class AVL
    attr_reader :root

    def initialize
      @root = nil
      @size = 0
    end

    def insert(key, value = nil)
      @root = insert_node(@root, key, value)
      @size += 1
    end

    def traverse(&block)
      traverse_node(@root, block)
    end

    def find(key)
      find_node(@root, key)
    end

    def size
      @size
    end

    private

    def find_node(node, key)
      return node if node.nil? || node.key == key

      return find_node(node.left, key) if key < node.key

      return find_node(node.right, key) if key >= node.key
    end

    def traverse_node(node, block)
      return :noop if node.nil?

      traverse_node(node.left, block)

      block.call({ key: node.key, value: node.value })

      traverse_node(node.right, block)
    end

    def height(node)
      return -1 if node.nil?

      node.height
    end

    def update_node_value(node, value)
      return if node.nil?

      node.value = value

      @size -= 1

      node
    end

    def insert_node(root, key, value)
      return Node.new(key, value) if root.nil?

      return update_node_value(root, value) if key == root.key

      if key < root.key
        root.left = insert_node(root.left, key, value)
      else
        root.right = insert_node(root.right, key, value)
      end

      update_height(root)

      node_balance_factor = balance_factor(root)

      if node_balance_factor > 1
        root.left = rotate_left(root.left) if key > root.left.key

        return rotate_right(root)
      elsif node_balance_factor < -1
        root.right = rotate_right(root.right) if key < root.right.key

        return rotate_left(root)
      end

      root
    end

    def rotate_right(x)
      a = x.left

      x.left = a.right
      a.right = x

      update_height(x)
      update_height(a)

      a
    end

    def rotate_left(a)
      x = a.right

      a.right = x.left
      x.left = a

      update_height(a)
      update_height(x)

      x
    end

    def update_height(node)
      node.height = [height(node.left), height(node.right)].max + 1
    end

    def balance_factor(node)
      height(node.left) - height(node.right)
    end
  end

  # TODO: This can be a simple Struct
  class Node
    attr_accessor :key, :value, :left, :right, :height

    def initialize(key, value = nil, left = nil, right = nil)
      @key = key
      @value = value
      @left = left
      @right = right
      @height = 0
    end
  end
end
