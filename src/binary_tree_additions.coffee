{ AVLTree, BinarySearchTree } = require('binary-search-tree')

# Append all elements in toAppend to array until the array has reach a certain capacity
#
# @param [Array] array the array to push the elements onto
# @param [Array] toAppend an array of elements to append to the array
# @param [Number] maxSize the maximum size the array we are appending on can reach
append = (array, toAppend, maxSize) ->
  i = 0

  for item in toAppend
    if array.length < maxSize
      array.push(item)
    else
      return

# Extension of the AVLTree class that allows for a descending in-order traversal
class ReversibleAVLTree extends AVLTree
  # Given a range of key values to bound between, return all of the items in the tree that fall within this range. Use a reversed in-order traversal limited to a count passed as a param.
  #
  # @param [Object] query the parameters for determining the parts of the subtree to return when traversing
  # @param [Number] count the maximum number of values to return from the tree
  # @return [Array<Object>] the items in the tree in descending in-order order
  betweenBoundsReversedTillCount: () ->
    return this.tree.betweenBoundsReversedTillCount.apply(this.tree, arguments)

# BinarySearchTree's prototype is appended to like this to ensure the version of BinarySearchTree used
# internally by any other classes will have this method available since we are expecting it to be there in our extension of AVLTree.
BinarySearchTree::betweenBoundsReversedTillCount = (query, count, lbm, ubm) ->
  res = []

  if !this.hasOwnProperty('key')
    return []

  lbm = lbm || this.getLowerBoundMatcher(query)
  ubm = ubm || this.getUpperBoundMatcher(query)

  if (ubm(this.key) && this.right && res.length < count)
    append(res, this.right.betweenBoundsReversedTillCount(query, count, lbm, ubm), count)
  if (lbm(this.key) && ubm(this.key) && res.length < count)
    append(res, this.data, count)
  if (lbm(this.key) && this.left && res.length < count)
    append(res, this.left.betweenBoundsReversedTillCount(query, count, lbm, ubm), count)

  return res

module.exports = { ReversibleAVLTree }
