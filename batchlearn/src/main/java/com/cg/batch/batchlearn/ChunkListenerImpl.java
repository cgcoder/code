package com.cg.batch.batchlearn;

import org.springframework.batch.core.ChunkListener;
import org.springframework.batch.core.scope.context.ChunkContext;

public class ChunkListenerImpl implements ChunkListener {

	@Override
	public void beforeChunk(ChunkContext context) {
		System.out.println("After Chunk");
	}

	@Override
	public void afterChunk(ChunkContext context) {
		System.out.println("Before Chunk");
	}

	@Override
	public void afterChunkError(ChunkContext context) {
		// TODO Auto-generated method stub
		
	}

}
