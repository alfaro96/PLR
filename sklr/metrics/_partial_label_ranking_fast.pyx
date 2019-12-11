# cython: language_level=3
# cython: cdivision=True
# cython: boundscheck=False
# cython: wraparound=False


# =============================================================================
# Methods
# =============================================================================

cpdef void penalized_kendall_distance_fast(INT64_t_2D Y_true,
                                           INT64_t_2D Y_pred,
                                           BOOL_t normalize,
                                           DTYPE_t_1D dists) nogil:
    """Fast version of penalized Kendall distance."""
    # Initialize some values from the input arrays
    cdef INT64_t n_samples = Y_true.shape[0]

    # Define the indexes
    cdef SIZE_t sample

    # Compute the penalized Kendall distances between
    # the pairwise true and predicted rankings
    for sample in range(n_samples):
        dists[sample] = _penalized_kendall_distance_fast(
            y_true=Y_true[sample], y_pred=Y_pred[sample], normalize=normalize)


cdef DTYPE_t _penalized_kendall_distance_fast(INT64_t_1D y_true,
                                              INT64_t_1D y_pred,
                                              BOOL_t normalize) nogil:
    """Fast version of penalized Kendall distance."""
    # Initialize some values from the input arrays
    cdef INT64_t n_classes = y_true.shape[0]

    # Define some variables to be employed
    cdef DTYPE_t dist

    # Define the indexes
    cdef SIZE_t sample
    cdef SIZE_t f_class
    cdef SIZE_t s_class

    # Initialize the penalized Kendall
    # distance between the rankings to zero
    dist = 0.0

    # Compute the penalized Kendall distance
    # between this true and predicted ranking
    for f_class in range(n_classes):
        for s_class in range(f_class + 1, n_classes):
            # Disagreement if "f_class" precedes "s_class"
            # in one ranking and "s_class" precedes "f_class"
            # in the other (or viceversa)
            if (y_true[f_class] < y_true[s_class] and
                    y_pred[f_class] > y_pred[s_class] or
                    y_true[f_class] > y_true[s_class] and
                    y_pred[f_class] < y_pred[s_class]):
                dist += 1
            # Penalized disagremeent if "f_class" precedes
            # "s_class" in one ranking and "f_class" is
            # tied with "s_class" in the other (or viceversa)
            elif (y_true[f_class] == y_true[s_class] and
                    y_pred[f_class] < y_pred[s_class] or
                    y_true[f_class] == y_true[s_class] and
                    y_pred[f_class] > y_pred[s_class] or
                    y_true[f_class] < y_true[s_class] and
                    y_pred[f_class] == y_pred[s_class] or
                    y_true[f_class] > y_true[s_class] and
                    y_pred[f_class] == y_pred[s_class]):
                dist += 0.5

    # Normalize the penalized Kendall distance (using
    # the number of different possible combinations)
    if normalize:
        dist /= (n_classes * (n_classes-1)) / 2

    # Return the penalized Kendall distance
    return dist


cpdef void tau_x_score_fast(INT64_t_2D Y_true,
                            INT64_t_2D Y_pred,
                            DTYPE_t_1D scores) nogil:
    """Fast version of Tau-x score."""
    # Initialize some values from the input arrays
    cdef INT64_t n_samples = Y_true.shape[0]

    # Define the indexes
    cdef SIZE_t sample

    # Compute the Tau-x scores between the
    # pairwise true and the predicted rankings
    for sample in range(n_samples):
        scores[sample] = _tau_x_score_fast(
            y_true=Y_true[sample], y_pred=Y_pred[sample])


cdef DTYPE_t _tau_x_score_fast(INT64_t_1D y_true,
                               INT64_t_1D y_pred) nogil:
    """Fast version of Tau-x score."""
    # Initialize some values from the input arrays
    cdef INT64_t n_classes = y_true.shape[0]

    # Define some variables to be employed
    cdef DTYPE_t score

    # Define the indexes
    cdef SIZE_t f_class
    cdef SIZE_t s_class

    # Initialize the Tau-x score
    # between the rankings to zero
    score = 0.0

    # Compute the Tau-x score
    for f_class in range(n_classes):
        for s_class in range(n_classes):
            # Bypass the same label
            if f_class == s_class:
                continue
            # Agreeement if "f_class" precedes "s_class"
            # in one ranking and "f_class" precedes "s_class"
            # in the other (or viceversa). Also, if "f_class"
            # precedes "s_class" in one ranking and "f_class"
            # is tied with "s_class" in the other (or viceversa)
            elif (y_true[f_class] < y_true[s_class] and
                    y_pred[f_class] < y_pred[s_class] or
                    y_true[f_class] < y_true[s_class] and
                    y_pred[f_class] == y_pred[s_class] or
                    y_true[f_class] == y_true[s_class] and
                    y_pred[f_class] < y_pred[s_class] or
                    y_true[f_class] == y_true[s_class] and
                    y_pred[f_class] == y_pred[s_class] or
                    y_true[f_class] > y_true[s_class] and
                    y_pred[f_class] > y_pred[s_class]):
                score += 1.0
            # Disagreement in any other case
            else:
                score -= 1.0

    # Normalize the Tau-x score (using the number
    # of different possible combinations)
    score /= (n_classes * (n_classes-1))

    # Return the Tau-x score
    return score