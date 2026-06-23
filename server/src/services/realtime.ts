import getSupabase from '../config/supabase';

const sb = getSupabase();

export type SubscriptionHandler = (payload: any) => void;

const subscriptions: Map<string, { unsubscribe: () => void }> = new Map();

export function subscribeToTable(
  channelName: string,
  table: string,
  event: 'INSERT' | 'UPDATE' | 'DELETE' | '*',
  filter?: string,
  handler?: SubscriptionHandler
) {
  if (subscriptions.has(channelName)) {
    return subscriptions.get(channelName)!;
  }

  let subscription = sb
    .channel(channelName)
    .on(
      'postgres_changes' as any,
      { event, schema: 'public', table, ...(filter ? { filter } : {}) },
      (payload: any) => {
        if (handler) handler(payload);
      }
    )
    .subscribe();

  const entry = {
    unsubscribe: () => {
      sb.removeChannel(subscription);
      subscriptions.delete(channelName);
    },
  };

  subscriptions.set(channelName, entry);
  return entry;
}

export function subscribeToNotifications(
  userId: string,
  handler: SubscriptionHandler
) {
  return subscribeToTable(
    `notifications:${userId}`,
    'notifications',
    'INSERT',
    `user_id=eq.${userId}`,
    handler
  );
}

export function subscribeToGrades(
  studentId: string,
  handler: SubscriptionHandler
) {
  return subscribeToTable(
    `grades:${studentId}`,
    'student_grades',
    '*',
    `student_id=eq.${studentId}`,
    handler
  );
}

export function subscribeToChat(
  userId: string,
  handler: SubscriptionHandler
) {
  return subscribeToTable(
    `chat:${userId}`,
    'chat_messages',
    'INSERT',
    `user_id=eq.${userId}`,
    handler
  );
}

export function unsubscribeAll() {
  subscriptions.forEach((entry) => entry.unsubscribe());
  subscriptions.clear();
}
