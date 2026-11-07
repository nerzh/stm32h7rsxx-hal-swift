// Copyright (c) 2022 STMicroelectronics. All rights reserved.
// SPDX-License-Identifier: BSD-3-Clause
// Queue operations from stm32h7rsxx_hal_dma_ex.c at
// 606ed7132ef1bc32c77fd9a040103bc98f23c748.
// See LICENSES/STM32H7RSxx-HAL-BSD-3-Clause.txt.

extension DMALinkedList {
    // HAL_DMAEx_List_InsertNode
    @discardableResult
    public func insertNode(in queueAddress: UInt32, after previousNode: UInt32, node newNode: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if ((queueAddress == 0) || (newNode == 0)) {
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        if (checkBaseAddresses(queueRef(queueAddress).head, previousNode, newNode) != 0) {
            queueRef(queueAddress).errorCode = 5
            return .error
        }
        if (checkNodeTypes(queueRef(queueAddress).head, previousNode, newNode) != 0) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        (linkMask, linkOffset) = cllrInfo(newNode)
        if (queueRef(queueAddress).head == 0) {
            if (previousNode == 0) {
                queueRef(queueAddress).head = newNode
                queueRef(queueAddress).nodeCount = 1
            } else {
                queueRef(queueAddress).head = previousNode
                words(previousNode)[linkOffset] = (newNode & 0xFFFC) | linkMask
                queueRef(queueAddress).nodeCount = 2
            }
        } else {
            if (previousNode == 0) {
                words(newNode)[linkOffset] = (queueRef(queueAddress).head & 0xFFFC) | linkMask
                queueRef(queueAddress).head = newNode
            } else {
                info.linkOffset = linkOffset
                if (findNode(queueAddress, previousNode, &info) == 0) {
                    if (info.position == queueRef(queueAddress).nodeCount) {
                        if (queueRef(queueAddress).firstCircularNode != 0) {
                            words(newNode)[linkOffset] = (queueRef(queueAddress).firstCircularNode & 0xFFFC) | linkMask
                        }
                        words(previousNode)[linkOffset] = (newNode & 0xFFFC) | linkMask
                    } else {
                        words(newNode)[linkOffset] = words(previousNode)[linkOffset]
                        words(previousNode)[linkOffset] = (newNode & 0xFFFC) | linkMask
                    }
                } else {
                    queueRef(queueAddress).errorCode = 6
                    return .error
                }
            }
            queueRef(queueAddress).nodeCount &+= 1
        }
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 1
        return .ok
    }

    // HAL_DMAEx_List_InsertNode_Head
    @discardableResult
    public func insertNodeAtHead(in queueAddress: UInt32, node newNode: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        if ((queueAddress == 0) || (newNode == 0)) {
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        if (checkBaseAddresses(queueRef(queueAddress).head, newNode, 0) != 0) {
            queueRef(queueAddress).errorCode = 5
            return .error
        }
        if (checkNodeTypes(queueRef(queueAddress).head, newNode, 0) != 0) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).head = newNode
        } else {
            (linkMask, linkOffset) = cllrInfo(newNode)
            words(newNode)[linkOffset] = (queueRef(queueAddress).head & 0xFFFC) | linkMask
            queueRef(queueAddress).head = newNode
        }
        queueRef(queueAddress).nodeCount &+= 1
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 1
        return .ok
    }

    // HAL_DMAEx_List_InsertNode_Tail
    @discardableResult
    public func insertNodeAtTail(in queueAddress: UInt32, node newNode: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if ((queueAddress == 0) || (newNode == 0)) {
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        if (checkBaseAddresses(queueRef(queueAddress).head, newNode, 0) != 0) {
            queueRef(queueAddress).errorCode = 5
            return .error
        }
        if (checkNodeTypes(queueRef(queueAddress).head, newNode, 0) != 0) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).head = newNode
        } else {
            (linkMask, linkOffset) = cllrInfo(newNode)
            info.linkOffset = linkOffset
            findNode(queueAddress, 0, &info)
            if (queueRef(queueAddress).firstCircularNode != 0) {
                words(newNode)[linkOffset] = (queueRef(queueAddress).firstCircularNode & 0xFFFC) | linkMask
            }
            words(info.currentAddress)[linkOffset] =
                (newNode & 0xFFFC) | linkMask
        }
        queueRef(queueAddress).nodeCount &+= 1
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 1
        return .ok
    }

    // HAL_DMAEx_List_RemoveNode
    @discardableResult
    public func removeNode(from queueAddress: UInt32, node nodeAddress: UInt32) -> HALStatus {
        var previousAddress: UInt32 = 0
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if ((queueAddress == 0) || (nodeAddress == 0)) {
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).errorCode = 2
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        linkOffset = cllrInfo(nodeAddress).offset
        info.linkOffset = linkOffset
        if (findNode(queueAddress, nodeAddress, &info) == 0) {
            if (info.position == 1) {
                if (queueRef(queueAddress).firstCircularNode == (info.currentAddress)) {
                    findNode(queueAddress, 0, &info)
                    words(info.currentAddress)[linkOffset] = 0
                    queueRef(queueAddress).firstCircularNode = 0
                }
                queueRef(queueAddress).head = ((queueRef(queueAddress).head & 0xFFFF_0000) &+
                    (words(nodeAddress)[linkOffset] & 0xFFFC))
                words(nodeAddress)[linkOffset] = 0
            } else if (info.position == queueRef(queueAddress).nodeCount) {
                words(info.previousAddress)[linkOffset] = 0
                words(info.currentAddress)[linkOffset] = 0
                queueRef(queueAddress).firstCircularNode = 0
            } else {
                previousAddress = info.previousAddress
                if (queueRef(queueAddress).firstCircularNode == (info.currentAddress)) {
                    findNode(queueAddress, 0, &info)
                    words(info.currentAddress)[linkOffset] = 0
                    queueRef(queueAddress).firstCircularNode = 0
                }
                words(previousAddress)[linkOffset] = words(nodeAddress)[linkOffset]
                words(nodeAddress)[linkOffset] = 0
            }
            queueRef(queueAddress).nodeCount &-= 1
        } else {
            queueRef(queueAddress).errorCode = 6
            return .error
        }
        if (queueRef(queueAddress).nodeCount == 0) {
            cleanQueue(queueAddress)
        } else {
            queueRef(queueAddress).errorCode = 0
            queueRef(queueAddress).state = 1
        }
        return .ok
    }

    // HAL_DMAEx_List_RemoveNode_Head
    @discardableResult
    public func removeNodeAtHead(from queueAddress: UInt32) -> HALStatus {
        var linkOffset: UInt32 = 0
        var currentAddress: UInt32 = 0
        var info = DMAListNodeInfo()
        if (queueAddress == 0) {
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).errorCode = 2
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        linkOffset = cllrInfo(queueRef(queueAddress).head).offset
        if (queueRef(queueAddress).nodeCount == 1) {
            words(queueRef(queueAddress).head)[linkOffset] = 0
            queueRef(queueAddress).firstCircularNode = 0
            queueRef(queueAddress).errorCode = 0
        } else {
            if (queueRef(queueAddress).firstCircularNode == queueRef(queueAddress).head) {
                info.linkOffset = linkOffset
                findNode(queueAddress, 0, &info)
                words(info.currentAddress)[linkOffset] = 0
                queueRef(queueAddress).firstCircularNode = 0
            }
            currentAddress = words(queueRef(queueAddress).head)[linkOffset] & 0xFFFC
            words(queueRef(queueAddress).head)[linkOffset] = 0
            queueRef(queueAddress).head = ((currentAddress &+ (queueRef(queueAddress).head & 0xFFFF_0000)))
        }
        queueRef(queueAddress).nodeCount &-= 1
        if (queueRef(queueAddress).nodeCount == 0) {
            cleanQueue(queueAddress)
        } else {
            queueRef(queueAddress).errorCode = 0
            queueRef(queueAddress).state = 1
        }
        return .ok
    }

    // HAL_DMAEx_List_RemoveNode_Tail
    @discardableResult
    public func removeNodeAtTail(from queueAddress: UInt32) -> HALStatus {
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if (queueAddress == 0) {
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).errorCode = 2
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        linkOffset = cllrInfo(queueRef(queueAddress).head).offset
        if (queueRef(queueAddress).nodeCount == 1) {
            words(queueRef(queueAddress).head)[linkOffset] = 0
            queueRef(queueAddress).firstCircularNode = 0
            queueRef(queueAddress).errorCode = 0
        } else {
            info.linkOffset = linkOffset
            findNode(queueAddress, 0, &info)
            words(info.previousAddress)[linkOffset] = 0
            words(info.currentAddress)[linkOffset] = 0
            queueRef(queueAddress).firstCircularNode = 0
        }
        queueRef(queueAddress).nodeCount &-= 1
        if (queueRef(queueAddress).nodeCount == 0) {
            cleanQueue(queueAddress)
        } else {
            queueRef(queueAddress).errorCode = 0
            queueRef(queueAddress).state = 1
        }
        return .ok
    }

    // HAL_DMAEx_List_ReplaceNode
    @discardableResult
    public func replaceNode(in queueAddress: UInt32, node oldNode: UInt32, with newNode: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if ((queueAddress == 0) || (oldNode == 0) || (newNode == 0)) {
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).errorCode = 2
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        if (checkBaseAddresses(queueRef(queueAddress).head, oldNode, newNode) != 0) {
            queueRef(queueAddress).errorCode = 5
            return .error
        }
        if (checkNodeTypes(queueRef(queueAddress).head, oldNode, newNode) != 0) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        (linkMask, linkOffset) = cllrInfo(newNode)
        info.linkOffset = linkOffset
        if (findNode(queueAddress, oldNode, &info) == 0) {
            if (info.position == 1) {
                words(newNode)[linkOffset] =
                    words(info.currentAddress)[linkOffset]
                queueRef(queueAddress).head = newNode
                words(info.currentAddress)[linkOffset] = 0
                if (queueRef(queueAddress).firstCircularNode == (info.currentAddress)) {
                    findNode(queueAddress, 0, &info)
                    words(info.currentAddress)[linkOffset] =
                        (newNode & 0xFFFC) | linkMask
                    queueRef(queueAddress).firstCircularNode = newNode
                }
            } else if (info.position == queueRef(queueAddress).nodeCount) {
                words(info.previousAddress)[linkOffset] =
                    (newNode & 0xFFFC) | linkMask
                words(info.currentAddress)[linkOffset] = 0
                if (queueRef(queueAddress).firstCircularNode == (info.currentAddress)) {
                    words(newNode)[linkOffset] = (newNode & 0xFFFC) | linkMask
                    queueRef(queueAddress).firstCircularNode = newNode
                } else if (queueRef(queueAddress).firstCircularNode != 0) {
                    words(newNode)[linkOffset] = (queueRef(queueAddress).firstCircularNode & 0xFFFC) | linkMask
                }
            } else {
                words(info.previousAddress)[linkOffset] =
                    (newNode & 0xFFFC) | linkMask
                words(newNode)[linkOffset] =
                    words(info.currentAddress)[linkOffset]
                words(info.currentAddress)[linkOffset] = 0
                if (queueRef(queueAddress).firstCircularNode == (info.currentAddress)) {
                    findNode(queueAddress, 0, &info)
                    words(info.currentAddress)[linkOffset] =
                        (newNode & 0xFFFC) | linkMask
                    queueRef(queueAddress).firstCircularNode = newNode
                }
            }
        } else {
            queueRef(queueAddress).errorCode = 6
            return .error
        }
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 1
        return .ok
    }

    // HAL_DMAEx_List_ReplaceNode_Head
    @discardableResult
    public func replaceNodeAtHead(in queueAddress: UInt32, with newNode: UInt32) -> HALStatus {
        var linkOffset: UInt32 = 0
        var linkMask: UInt32 = 0
        var info = DMAListNodeInfo()
        if ((queueAddress == 0) || (newNode == 0)) {
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).errorCode = 2
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        if (checkBaseAddresses(queueRef(queueAddress).head, newNode, 0) != 0) {
            queueRef(queueAddress).errorCode = 5
            return .error
        }
        if (checkNodeTypes(queueRef(queueAddress).head, newNode, 0) != 0) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        (linkMask, linkOffset) = cllrInfo(newNode)
        if (queueRef(queueAddress).firstCircularNode == queueRef(queueAddress).head) {
            info.linkOffset = linkOffset
            findNode(queueAddress, 0, &info)
            words(info.currentAddress)[linkOffset] =
                (newNode & 0xFFFC) | linkMask
            queueRef(queueAddress).firstCircularNode = newNode
        }
        words(newNode)[linkOffset] = words(queueRef(queueAddress).head)[linkOffset]
        words(queueRef(queueAddress).head)[linkOffset] = 0
        queueRef(queueAddress).head = newNode
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 1
        return .ok
    }

    // HAL_DMAEx_List_ReplaceNode_Tail
    @discardableResult
    public func replaceNodeAtTail(in queueAddress: UInt32, with newNode: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if ((queueAddress == 0) || (newNode == 0)) {
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).errorCode = 2
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        (linkMask, linkOffset) = cllrInfo(newNode)
        info.linkOffset = linkOffset
        findNode(queueAddress, 0, &info)
        words(info.previousAddress)[linkOffset] =
            (newNode & 0xFFFC) | linkMask
        words(info.currentAddress)[linkOffset] = 0
        if (queueRef(queueAddress).firstCircularNode == (info.currentAddress)) {
            words(newNode)[linkOffset] = (newNode & 0xFFFC) | linkMask
            queueRef(queueAddress).firstCircularNode = newNode
        } else if (queueRef(queueAddress).firstCircularNode != 0) {
            words(newNode)[linkOffset] = (queueRef(queueAddress).firstCircularNode & 0xFFFC) | linkMask
        }
        if (queueRef(queueAddress).nodeCount == 1) {
            queueRef(queueAddress).head = newNode
        }
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 1
        return .ok
    }

    // HAL_DMAEx_List_ResetQ
    @discardableResult
    public func resetQueue(at queueAddress: UInt32) -> HALStatus {
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if (queueAddress == 0) {
            return .error
        }
        if (queueRef(queueAddress).state == 2) {
            queueRef(queueAddress).errorCode = 1
            return .error
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        if (queueRef(queueAddress).head != 0) {
            linkOffset = cllrInfo(queueRef(queueAddress).head).offset
            info.linkOffset = linkOffset
            resetQueueNodes(queueAddress, info)
        }
        queueRef(queueAddress).head = 0
        queueRef(queueAddress).nodeCount = 0
        queueRef(queueAddress).firstCircularNode = 0
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 0
        return .ok
    }

    // HAL_DMAEx_List_InsertQ
    @discardableResult
    public func insertQueue(in destinationQueue: UInt32, after previousNode: UInt32, queue sourceQueue: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        var sourceInfo = DMAListNodeInfo()
        var destinationInfo = DMAListNodeInfo()
        if ((sourceQueue == 0) || (destinationQueue == 0)) {
            return .error
        }
        if (queueRef(sourceQueue).head == 0) {
            queueRef(sourceQueue).errorCode = 2
            return .error
        }
        if (queueRef(sourceQueue).type == 1) {
            queueRef(sourceQueue).errorCode = 4
            return .error
        }
        if (queueRef(destinationQueue).type == 1) {
            queueRef(destinationQueue).errorCode = 4
            return .error
        }
        if (queueRef(sourceQueue).firstCircularNode != 0) {
            queueRef(sourceQueue).errorCode = 4
            return .error
        }
        if (checkBaseAddresses(queueRef(sourceQueue).head, previousNode, queueRef(destinationQueue).head) != 0) {
            queueRef(sourceQueue).errorCode = 5
            queueRef(destinationQueue).errorCode = 5
            return .error
        }
        if (checkNodeTypes(queueRef(sourceQueue).head, previousNode, queueRef(destinationQueue).head) != 0) {
            queueRef(sourceQueue).errorCode = 4
            queueRef(destinationQueue).errorCode = 4
            return .error
        }
        queueRef(sourceQueue).state = 2
        queueRef(sourceQueue).errorCode = 0
        queueRef(destinationQueue).state = 2
        queueRef(destinationQueue).errorCode = 0
        (linkMask, linkOffset) = cllrInfo(queueRef(sourceQueue).head)
        if (queueRef(destinationQueue).head == 0) {
            queueRef(destinationQueue).head = queueRef(sourceQueue).head
            queueRef(destinationQueue).nodeCount = queueRef(sourceQueue).nodeCount
        } else {
            if (previousNode == 0) {
                sourceInfo.linkOffset = linkOffset
                findNode(sourceQueue, 0, &sourceInfo)
                if (queueRef(destinationQueue).firstCircularNode == queueRef(destinationQueue).head) {
                    destinationInfo.linkOffset = linkOffset
                    findNode(destinationQueue, 0, &destinationInfo)
                    words(destinationInfo.currentAddress)[linkOffset] =
                        (queueRef(sourceQueue).head & 0xFFFC) | linkMask
                    queueRef(destinationQueue).firstCircularNode = queueRef(sourceQueue).head
                }
                words(sourceInfo.currentAddress)[linkOffset] =
                    (queueRef(destinationQueue).head & 0xFFFC) | linkMask
                queueRef(destinationQueue).head = queueRef(sourceQueue).head
                queueRef(destinationQueue).nodeCount &+= queueRef(sourceQueue).nodeCount
            } else {
                destinationInfo.linkOffset = linkOffset
                if (findNode(destinationQueue, previousNode, &destinationInfo) == 0) {
                    if (destinationInfo.position == queueRef(destinationQueue).nodeCount) {
                        words(destinationInfo.currentAddress)[linkOffset] =
                            (queueRef(sourceQueue).head & 0xFFFC) | linkMask
                        queueRef(destinationQueue).nodeCount &+= queueRef(sourceQueue).nodeCount
                        if (queueRef(destinationQueue).firstCircularNode != 0) {
                            sourceInfo.linkOffset = linkOffset
                            findNode(sourceQueue, 0, &sourceInfo)
                            findNode(destinationQueue, queueRef(destinationQueue).firstCircularNode, &destinationInfo)
                            words(sourceInfo.currentAddress)[linkOffset] =
                                (destinationInfo.currentAddress & 0xFFFC) | linkMask
                        }
                    } else {
                        words(destinationInfo.currentAddress)[linkOffset] =
                            (queueRef(sourceQueue).head & 0xFFFC) | linkMask
                        sourceInfo.linkOffset = linkOffset
                        findNode(sourceQueue, 0, &sourceInfo)
                        words(sourceInfo.currentAddress)[linkOffset] =
                            (destinationInfo.nextAddress & 0xFFFC) | linkMask
                        queueRef(destinationQueue).nodeCount &+= queueRef(sourceQueue).nodeCount
                    }
                } else {
                    queueRef(destinationQueue).errorCode = 6
                    return .error
                }
            }
        }
        cleanQueue(sourceQueue)
        queueRef(destinationQueue).errorCode = 0
        queueRef(destinationQueue).state = 1
        return .ok
    }

    // HAL_DMAEx_List_InsertQ_Head
    @discardableResult
    public func insertQueueAtHead(in destinationQueue: UInt32, queue sourceQueue: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        var sourceInfo = DMAListNodeInfo()
        var destinationInfo = DMAListNodeInfo()
        if ((sourceQueue == 0) || (destinationQueue == 0)) {
            return .error
        }
        if (queueRef(sourceQueue).head == 0) {
            queueRef(sourceQueue).errorCode = 2
            return .error
        }
        if (queueRef(sourceQueue).type == 1) {
            queueRef(sourceQueue).errorCode = 4
            return .error
        }
        if (queueRef(destinationQueue).type == 1) {
            queueRef(destinationQueue).errorCode = 4
            return .error
        }
        if (checkBaseAddresses(queueRef(sourceQueue).head, queueRef(destinationQueue).head, 0) != 0) {
            queueRef(sourceQueue).errorCode = 5
            queueRef(destinationQueue).errorCode = 5
            return .error
        }
        if (checkNodeTypes(queueRef(sourceQueue).head, queueRef(destinationQueue).head, 0) != 0) {
            queueRef(sourceQueue).errorCode = 4
            queueRef(destinationQueue).errorCode = 4
            return .error
        }
        queueRef(sourceQueue).state = 2
        queueRef(sourceQueue).errorCode = 0
        queueRef(destinationQueue).state = 2
        queueRef(destinationQueue).errorCode = 0
        (linkMask, linkOffset) = cllrInfo(queueRef(sourceQueue).head)
        if (queueRef(destinationQueue).head == 0) {
            queueRef(destinationQueue).head = queueRef(sourceQueue).head
            queueRef(destinationQueue).nodeCount = queueRef(sourceQueue).nodeCount
        } else {
            sourceInfo.linkOffset = linkOffset
            findNode(sourceQueue, 0, &sourceInfo)
            if (queueRef(destinationQueue).firstCircularNode == queueRef(destinationQueue).head) {
                destinationInfo.linkOffset = linkOffset
                findNode(destinationQueue, 0, &destinationInfo)
                words(destinationInfo.currentAddress)[linkOffset] =
                    (queueRef(sourceQueue).head & 0xFFFC) | linkMask
                queueRef(destinationQueue).firstCircularNode = queueRef(sourceQueue).head
            }
            words(sourceInfo.currentAddress)[linkOffset] =
                (queueRef(destinationQueue).head & 0xFFFC) | linkMask
            queueRef(destinationQueue).head = queueRef(sourceQueue).head
            queueRef(destinationQueue).nodeCount &+= queueRef(sourceQueue).nodeCount
        }
        cleanQueue(sourceQueue)
        queueRef(destinationQueue).errorCode = 0
        queueRef(destinationQueue).state = 1
        return .ok
    }

    // HAL_DMAEx_List_InsertQ_Tail
    @discardableResult
    public func insertQueueAtTail(in destinationQueue: UInt32, queue sourceQueue: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        var sourceInfo = DMAListNodeInfo()
        var destinationInfo = DMAListNodeInfo()
        if ((sourceQueue == 0) || (destinationQueue == 0)) {
            return .error
        }
        if (queueRef(sourceQueue).head == 0) {
            queueRef(sourceQueue).errorCode = 2
            return .error
        }
        if (queueRef(sourceQueue).type == 1) {
            queueRef(sourceQueue).errorCode = 4
            return .error
        }
        if (queueRef(destinationQueue).type == 1) {
            queueRef(destinationQueue).errorCode = 4
            return .error
        }
        if (checkBaseAddresses(queueRef(sourceQueue).head, queueRef(destinationQueue).head, 0) != 0) {
            queueRef(sourceQueue).errorCode = 5
            queueRef(destinationQueue).errorCode = 5
            return .error
        }
        if (checkNodeTypes(queueRef(sourceQueue).head, queueRef(destinationQueue).head, 0) != 0) {
            queueRef(sourceQueue).errorCode = 4
            queueRef(destinationQueue).errorCode = 4
            return .error
        }
        queueRef(sourceQueue).state = 2
        queueRef(sourceQueue).errorCode = 0
        queueRef(destinationQueue).state = 2
        queueRef(destinationQueue).errorCode = 0
        (linkMask, linkOffset) = cllrInfo(queueRef(sourceQueue).head)
        if (queueRef(destinationQueue).head == 0) {
            queueRef(destinationQueue).head = queueRef(sourceQueue).head
            queueRef(destinationQueue).nodeCount = queueRef(sourceQueue).nodeCount
        } else {
            destinationInfo.linkOffset = linkOffset
            findNode(destinationQueue, 0, &destinationInfo)
            words(destinationInfo.currentAddress)[linkOffset] =
                (queueRef(sourceQueue).head & 0xFFFC) | linkMask
            queueRef(destinationQueue).nodeCount &+= queueRef(sourceQueue).nodeCount
            if (queueRef(destinationQueue).firstCircularNode != 0) {
                sourceInfo.linkOffset = linkOffset
                findNode(sourceQueue, 0, &sourceInfo)
                findNode(destinationQueue, queueRef(destinationQueue).firstCircularNode, &destinationInfo)
                words(sourceInfo.currentAddress)[linkOffset] =
                    (destinationInfo.currentAddress & 0xFFFC) | linkMask
            }
        }
        cleanQueue(sourceQueue)
        queueRef(destinationQueue).errorCode = 0
        queueRef(destinationQueue).state = 1
        return .ok
    }

    // HAL_DMAEx_List_SetCircularModeConfig
    @discardableResult
    public func configureCircularMode(in queueAddress: UInt32, firstCircularNode: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if ((queueAddress == 0) || (firstCircularNode == 0)) {
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).errorCode = 2
            return .error
        }
        if (queueRef(queueAddress).firstCircularNode != 0) {
            if (queueRef(queueAddress).firstCircularNode == firstCircularNode) {
                return .ok
            } else {
                queueRef(queueAddress).errorCode = 4
                return .error
            }
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        (linkMask, linkOffset) = cllrInfo(firstCircularNode)
        info.linkOffset = linkOffset
        if (findNode(queueAddress, firstCircularNode, &info) == 0) {
            findNode(queueAddress, 0, &info)
            words(info.currentAddress)[linkOffset] =
                (firstCircularNode & 0xFFFC) | linkMask
            queueRef(queueAddress).firstCircularNode = firstCircularNode
        } else {
            queueRef(queueAddress).errorCode = 6
            return .error
        }
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 1
        return .ok
    }

    // HAL_DMAEx_List_SetCircularMode
    @discardableResult
    public func setCircularMode(in queueAddress: UInt32) -> HALStatus {
        var linkMask: UInt32 = 0
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if (queueAddress == 0) {
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).errorCode = 2
            return .error
        }
        if (queueRef(queueAddress).firstCircularNode != 0) {
            if (queueRef(queueAddress).firstCircularNode == queueRef(queueAddress).head) {
                return .ok
            } else {
                queueRef(queueAddress).errorCode = 4
                return .error
            }
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        (linkMask, linkOffset) = cllrInfo(queueRef(queueAddress).head)
        info.linkOffset = linkOffset
        findNode(queueAddress, 0, &info)
        words(info.currentAddress)[linkOffset] =
            (queueRef(queueAddress).head & 0xFFFC) | linkMask
        queueRef(queueAddress).firstCircularNode = queueRef(queueAddress).head
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 1
        return .ok
    }

    // HAL_DMAEx_List_ClearCircularMode
    @discardableResult
    public func clearCircularMode(in queueAddress: UInt32) -> HALStatus {
        var linkOffset: UInt32 = 0
        var info = DMAListNodeInfo()
        if (queueAddress == 0) {
            return .error
        }
        if (queueRef(queueAddress).head == 0) {
            queueRef(queueAddress).errorCode = 2
            return .error
        }
        if (queueRef(queueAddress).firstCircularNode == 0) {
            return .ok
        }
        if (queueRef(queueAddress).type == 1) {
            queueRef(queueAddress).errorCode = 4
            return .error
        }
        queueRef(queueAddress).state = 2
        queueRef(queueAddress).errorCode = 0
        linkOffset = cllrInfo(queueRef(queueAddress).head).offset
        info.linkOffset = linkOffset
        findNode(queueAddress, 0, &info)
        words(info.currentAddress)[linkOffset] = 0
        queueRef(queueAddress).firstCircularNode = 0
        queueRef(queueAddress).errorCode = 0
        queueRef(queueAddress).state = 1
        return .ok
    }

}

// These references map each word explicitly. Their Swift layout is never
// exposed to the peripheral; setters perform the corresponding memory write.
struct DMAListWords<Memory: DMAMemoryIO> {
    let memory: Memory
    let address: UInt32
    subscript(index: UInt32) -> UInt32 {
        get { memory.read32(at: address &+ (index &* 4)) }
        nonmutating set { memory.write32(at: address &+ (index &* 4), value: newValue) }
    }
}

struct DMAListQueueReference<Memory: DMAMemoryIO> {
    let memory: Memory
    let address: UInt32
    var head: UInt32 {
        get { memory.read32(at: address &+ 0) }
        nonmutating set { memory.write32(at: address &+ 0, value: newValue) }
    }
    var firstCircularNode: UInt32 {
        get { memory.read32(at: address &+ 4) }
        nonmutating set { memory.write32(at: address &+ 4, value: newValue) }
    }
    var nodeCount: UInt32 {
        get { memory.read32(at: address &+ 8) }
        nonmutating set { memory.write32(at: address &+ 8, value: newValue) }
    }
    var state: UInt32 {
        get { memory.read32(at: address &+ 12) }
        nonmutating set { memory.write32(at: address &+ 12, value: newValue) }
    }
    var errorCode: UInt32 {
        get { memory.read32(at: address &+ 16) }
        nonmutating set { memory.write32(at: address &+ 16, value: newValue) }
    }
    var type: UInt32 {
        get { memory.read32(at: address &+ 20) }
        nonmutating set { memory.write32(at: address &+ 20, value: newValue) }
    }
}

struct DMAListNodeInfo {
    var position: UInt32 = 0
    var previousAddress: UInt32 = 0
    var currentAddress: UInt32 = 0
    var nextAddress: UInt32 = 0
    var linkOffset: UInt32 = 0
}

extension DMALinkedList {
    func words(_ address: UInt32) -> DMAListWords<Memory> { .init(memory: memory, address: address) }
    func queueRef(_ address: UInt32) -> DMAListQueueReference<Memory> { .init(memory: memory, address: address) }

    func checkBaseAddresses(_ first: UInt32, _ second: UInt32, _ third: UInt32) -> UInt32 {
        // Preserve the HAL's OR-based comparison, including overlapping bases.
        let combined = (first | second | third) & 0xFFFF_0000
        var reference: UInt32 = 0
        if first != 0 { reference = first }
        else if second != 0 { reference = second }
        else if third != 0 { reference = third }
        if combined != reference & 0xFFFF_0000 { return 1 }
        return 0
    }

    func checkNodeTypes(_ first: UInt32, _ second: UInt32, _ third: UInt32) -> UInt32 {
        var reference: UInt32 = 0
        if first != 0 { reference = node(first, 8) & 0xFF }
        else if second != 0 { reference = node(second, 8) & 0xFF }
        else if third != 0 { reference = node(third, 8) & 0xFF }
        if second != 0 {
            if reference != node(second, 8) & 0xFF { return 2 }
        }
        if third != 0 {
            if reference != node(third, 8) & 0xFF { return 3 }
        }
        return 0
    }

    @discardableResult
    func findNode(_ queueAddress: UInt32, _ nodeAddress: UInt32, _ info: inout DMAListNodeInfo) -> UInt32 {
        var index: UInt32 = 0
        var current: UInt32 = 0
        var previous: UInt32 = 0
        let offset = info.linkOffset
        if nodeAddress == 0 {
            while index < queue(queueAddress, .nodeCount) {
                if index == 0 { current = queue(queueAddress, .head) & 0xFFFC }
                else {
                    previous = current
                    current = node(current &+ (queue(queueAddress, .head) & 0xFFFF_0000), offset) & 0xFFFC
                }
                index &+= 1
            }
        } else {
            while index < queue(queueAddress, .nodeCount) && current != nodeAddress & 0xFFFC {
                if index == 0 { current = queue(queueAddress, .head) & 0xFFFC }
                else {
                    previous = current
                    current = node(current &+ (queue(queueAddress, .head) & 0xFFFF_0000), offset) & 0xFFFC
                }
                index &+= 1
            }
        }
        if nodeAddress != 0 {
            if current != nodeAddress & 0xFFFC { return 1 }
        }
        info.position = index
        info.previousAddress = previous | (queue(queueAddress, .head) & 0xFFFF_0000)
        info.currentAddress = current | (queue(queueAddress, .head) & 0xFFFF_0000)
        if node(info.currentAddress, offset) != 0 {
            info.nextAddress = (node(info.currentAddress, offset) & 0xFFFC) | (queue(queueAddress, .head) & 0xFFFF_0000)
        }
        return 0
    }

    func resetQueueNodes(_ queueAddress: UInt32, _ info: DMAListNodeInfo) {
        var index: UInt32 = 0
        var current: UInt32 = 0
        var previous: UInt32
        let offset = info.linkOffset
        while index < queue(queueAddress, .nodeCount) {
            if index == 0 {
                previous = queue(queueAddress, .head) & 0xFFFC
                current = node(queue(queueAddress, .head), offset) & 0xFFFC
            } else {
                previous = current
                current = node(current &+ (queue(queueAddress, .head) & 0xFFFF_0000), offset) & 0xFFFC
            }
            setNode(previous &+ (queue(queueAddress, .head) & 0xFFFF_0000), offset, 0)
            index &+= 1
        }
    }

    func cleanQueue(_ address: UInt32) {
        setQueue(address, .head, 0)
        setQueue(address, .firstCircularNode, 0)
        setQueue(address, .nodeCount, 0)
        setQueue(address, .state, 0)
        setQueue(address, .errorCode, 0)
        setQueue(address, .type, 0)
    }
}
