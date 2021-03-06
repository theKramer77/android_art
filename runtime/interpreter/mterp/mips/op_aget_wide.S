    /*
     * Array get, 64 bits.  vAA <- vBB[vCC].
     *
     * Arrays of long/double are 64-bit aligned.
     */
    /* aget-wide vAA, vBB, vCC */
    FETCH(a0, 1)                           #  a0 <- CCBB
    GET_OPA(rOBJ)                          #  rOBJ <- AA
    and       a2, a0, 255                  #  a2 <- BB
    srl       a3, a0, 8                    #  a3 <- CC
    GET_VREG(a0, a2)                       #  a0 <- vBB (array object)
    GET_VREG(a1, a3)                       #  a1 <- vCC (requested index)
    # null array object?
    beqz      a0, common_errNullObject     #  yes, bail
    LOAD_base_offMirrorArray_length(a3, a0) #  a3 <- arrayObj->length
    EAS3(a0, a0, a1)                       #  a0 <- arrayObj + index*width
    bgeu      a1, a3, common_errArrayIndex #  index >= length, bail

    FETCH_ADVANCE_INST(2)                  #  advance rPC, load rINST
    LOAD64_off(a2, a3, a0, MIRROR_WIDE_ARRAY_DATA_OFFSET)
    GET_INST_OPCODE(t0)                    #  extract opcode from rINST
    SET_VREG64_GOTO(a2, a3, rOBJ, t0)      #  vAA/vAA+1 <- a2/a3
