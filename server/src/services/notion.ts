import axios from 'axios';
import { config } from '../config';

const NOTION_VERSION = '2022-06-28';

function notionClient() {
  return axios.create({
    baseURL: 'https://api.notion.com/v1',
    headers: {
      Authorization: `Bearer ${config.notion.apiKey}`,
      'Notion-Version': NOTION_VERSION,
      'Content-Type': 'application/json',
    },
    timeout: 15000,
  });
}

export async function createPage(databaseId: string, properties: Record<string, any>) {
  const { data } = await notionClient().post('/pages', {
    parent: { database_id: databaseId },
    properties,
  });
  return data;
}

export async function queryDatabase(databaseId: string, filter?: any) {
  const { data } = await notionClient().post(`/databases/${databaseId}/query`, {
    filter,
  });
  return data.results;
}

export async function appendBlockChildren(blockId: string, children: any[]) {
  const { data } = await notionClient().patch(`/blocks/${blockId}/children`, {
    children,
  });
  return data;
}

export async function getPage(pageId: string) {
  const { data } = await notionClient().get(`/pages/${pageId}`);
  return data;
}

export async function getBlockChildren(blockId: string) {
  const { data } = await notionClient().get(`/blocks/${blockId}/children`);
  return data.results;
}

export async function searchNotion(query: string) {
  const { data } = await notionClient().post('/search', {
    query,
    filter: { value: 'page', property: 'object' },
  });
  return data.results;
}

export async function storeLessonPlan(lessonData: {
  title: string;
  subject: string;
  className: string;
  content: string;
  objectives: string[];
}) {
  if (!config.notion.lessonsDatabaseId) {
    return null;
  }
  return createPage(config.notion.lessonsDatabaseId, {
    title: { title: [{ text: { content: lessonData.title } }] },
    Subject: { select: { name: lessonData.subject } },
    Class: { select: { name: lessonData.className } },
    Objectives: { rich_text: [{ text: { content: lessonData.objectives.join(', ') } }] },
    Status: { status: { name: 'Draft' } },
  });
}

export async function storeGeneratedVideo(videoData: {
  title: string;
  subject: string;
  script: string;
  videoUrl?: string;
}) {
  if (!config.notion.videosDatabaseId) {
    return null;
  }
  return createPage(config.notion.videosDatabaseId, {
    title: { title: [{ text: { content: videoData.title } }] },
    Subject: { select: { name: videoData.subject } },
    Script: { rich_text: [{ text: { content: videoData.script.substring(0, 2000) } }] },
    Status: { status: { name: videoData.videoUrl ? 'Published' : 'Script Ready' } },
    ...(videoData.videoUrl
      ? { 'Video URL': { url: videoData.videoUrl } }
      : {}),
  });
}
