import asyncHandler from 'express-async-handler';
import UserNotification from '../models/UserNotification.model.js';
import ApiError from '../utils/apiError.js';

/**
 * @desc    Create a new notification
 * @route   POST /api/v1/notifications
 * @access  Private
 */
export const createNotification = asyncHandler(async (req, res, next) => {
  const { title, body, imageUrl, type, actionUrl, data } = req.body;

  const notification = await UserNotification.create({
    userId: req.user._id,
    title,
    body,
    imageUrl,
    type,
    actionUrl,
    data,
  });

  res.status(201).json({
    status: 'success',
    data: notification,
  });
});

export const getMyNotifications = asyncHandler(async (req, res, next) => {
  const { filterBy, sort } = req.query;

  // Base query always filters by current user
  const query = { userId: req.user._id };

  // Apply filters based on filterBy parameter
  switch (filterBy) {
    case 'read':
      query.isRead = true;
      break;

    case 'unRead':
      query.isRead = false;
      break;

    case 'all':
    default:
      // No additional filters needed for 'all'
      break;
  }

  // Create and configure the mongoose query
  let mongooseQuery = UserNotification.find(query);

  // Handle sorting
  if (sort) {
    const sortBy = sort.split(',').join(' ');
    mongooseQuery = mongooseQuery.sort(sortBy);
  } else {
    mongooseQuery = mongooseQuery.sort('-createdAt');
  }

  const notifications = await mongooseQuery;

  res.status(200).json({
    status: 'success',
    results: notifications.length,
    data: notifications,
  });
});

/**
 * @desc    Mark a notification as read
 * @route   PATCH /api/v1/notifications/:notificationId/read
 * @access  Private
 */
export const markAsRead = asyncHandler(async (req, res, next) => {
  const { notificationId } = req.params;

  const notification = await UserNotification.findOneAndUpdate(
    {
      _id: notificationId,
      userId: req.user._id,
    },
    { isRead: true },
    { new: true }
  );

  if (!notification) {
    return next(new ApiError('Notification not found', 404));
  }

  res.status(200).json({
    status: 'success',
    data: notification,
  });
});

/**
 * @desc    Mark all notifications as read
 * @route   PATCH /api/v1/notifications/read-all
 * @access  Private
 */
export const markAllAsRead = asyncHandler(async (req, res, next) => {
  await UserNotification.updateMany(
    {
      userId: req.user._id,
      isRead: false,
    },
    { isRead: true }
  );

  res.status(200).json({
    status: 'success',
    message: 'All notifications marked as read',
  });
});

/**
 * @desc    Delete a notification
 * @route   DELETE /api/v1/notifications/:notificationId
 * @access  Private
 */
export const deleteNotification = asyncHandler(async (req, res, next) => {
  const { notificationId } = req.params;

  const notification = await UserNotification.findOneAndDelete({
    _id: notificationId,
    userId: req.user._id,
  });

  if (!notification) {
    return next(new ApiError('Notification not found', 404));
  }

  res.status(200).json({
    status: 'success',
    message: 'Notification deleted successfully',
  });
});

/**
 * @desc    Get unread notifications count
 * @route   GET /api/v1/notifications/unread-count
 * @access  Private
 */
export const getUnreadCount = asyncHandler(async (req, res, next) => {
  const count = await UserNotification.countDocuments({
    userId: req.user._id,
    isRead: false,
  });

  res.status(200).json({
    status: 'success',
    data: {
      unreadCount: count,
    },
  });
});

/**
 * @desc    Get all notifications (admin only)
 * @route   GET /api/v1/notifications/all
 * @access  Private/Admin
 */
export const getAllNotifications = asyncHandler(async (req, res, next) => {
  const notifications = await UserNotification.find()
    .sort('-createdAt')
    .populate('userId', 'name email');

  res.status(200).json({
    status: 'success',
    results: notifications.length,
    data: notifications,
  });
});

/**
 * @desc    Clear all notifications for a user
 * @route   DELETE /api/v1/notifications
 * @access  Private
 */
export const clearAllNotifications = asyncHandler(async (req, res, next) => {
  const result = await UserNotification.deleteMany({ userId: req.user._id });

  res.status(200).json({
    status: 'success',
    message: 'All notifications deleted successfully',
    deletedCount: result.deletedCount,
  });
});
