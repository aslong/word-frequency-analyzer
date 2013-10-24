###*
# The test project
#
# @module binary-tree-additions
# @author aslong
###

{ AVLTree, BinarySearchTree } = require('binary-search-tree')

# Append all elements in toAppend to array
append = (array, toAppend, maxSize) ->
  i = 0

  for item in toAppend
    if array.length < maxSize
      array.push(item)
    else
      return

AVLTree.prototype.betweenBoundsReverseTillCount = () ->
  return this.tree.betweenBoundsReverseTillCount.apply(this.tree, arguments)

BinarySearchTree.prototype.betweenBoundsReverseTillCount = (query, count, lbm, ubm) ->
  res = []

  if !this.hasOwnProperty('key')
    return []

  lbm = lbm || this.getLowerBoundMatcher(query)
  ubm = ubm || this.getUpperBoundMatcher(query)

  if (ubm(this.key) && this.right && res.length < count)
    append(res, this.right.betweenBoundsReverseTillCount(query, count, lbm, ubm), count)
  if (lbm(this.key) && ubm(this.key) && res.length < count)
    append(res, this.data, count)
  if (lbm(this.key) && this.left && res.length < count)
    append(res, this.left.betweenBoundsReverseTillCount(query, count, lbm, ubm), count)

  return res

module.exports.AVLTree = AVLTree
